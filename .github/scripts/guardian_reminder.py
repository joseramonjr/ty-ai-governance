import urllib.request
import urllib.parse
import json
import os
import base64
from datetime import datetime, timezone

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
RESEND_API_KEY = os.environ["RESEND_API_KEY"]
TWILIO_ACCOUNT_SID = os.environ["TWILIO_ACCOUNT_SID"]
TWILIO_AUTH_TOKEN = os.environ["TWILIO_AUTH_TOKEN"]
TWILIO_PHONE_NUMBER = os.environ["TWILIO_PHONE_NUMBER"]
GUARDIAN_PHONE_NUMBER = os.environ["GUARDIAN_PHONE_NUMBER"]
GUARDIAN_EMAIL = os.environ["GUARDIAN_EMAIL"]

REMINDER_DAYS = [182, 304, 334, 355, 0]

url = f"{SUPABASE_URL}/rest/v1/guardian_authority?select=guardian_name,last_checkin_at,next_checkin_due&order=created_at.desc&limit=1"
req = urllib.request.Request(url, headers={
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json"
})
with urllib.request.urlopen(req) as res:
    data = json.loads(res.read())[0]

last_checkin = datetime.fromisoformat(data["last_checkin_at"].replace("Z", "+00:00"))
now = datetime.now(timezone.utc)
days_elapsed = (now - last_checkin).days
days_remaining = 365 - days_elapsed

print(f"Guardian: {data['guardian_name']}")
print(f"Last check-in: {last_checkin.strftime('%Y-%m-%d')}")
print(f"Days elapsed: {days_elapsed}")
print(f"Days remaining: {days_remaining}")

if days_elapsed not in REMINDER_DAYS:
    print("No reminder needed today.")
    exit(0)

reminder_map = {182: "6-month", 304: "10-month", 334: "11-month", 355: "12-month"}
reminder_type = reminder_map[days_elapsed]
print(f"Sending {reminder_type} reminder...")

warning = ""
if days_remaining <= 30:
    warning = "\nWARNING: Your deadline is approaching. Please check in as soon as possible.\n"

email_body = f"""Hello {data['guardian_name']},

This is your {reminder_type} reminder to perform your annual TY AI OS Guardian Check-In.

Current status:
- Last check-in: {last_checkin.strftime('%B %d, %Y')}
- Days elapsed: {days_elapsed}
- Days remaining before deadline: {days_remaining}
{warning}
To perform your check-in:
1. Insert your USB drive (F:\\guardian_private.key)
2. Open Jaya Runtime with technical assistance
3. Navigate to Identity > Guardian Check-In
4. Enter F:\\guardian_private.key in the key field
5. Click Sign Guardian Check-In

If you need assistance refer to your SOP document or contact Jose Ramon.

This message was sent automatically by TY AI OS.
-- TY AI OS Guardian Reminder System"""

email_data = json.dumps({
    "from": "TY AI OS <noreply@silversounds321.com>",
    "to": GUARDIAN_EMAIL,
    "subject": f"TY AI OS -- Guardian Check-In Reminder ({reminder_type})",
    "text": email_body
}).encode()
email_req = urllib.request.Request(
    "https://api.resend.com/emails",
    data=email_data,
    headers={
        "Authorization": f"Bearer {RESEND_API_KEY}",
        "Content-Type": "application/json"
    }
)
with urllib.request.urlopen(email_req) as res:
    print(f"Email sent: {res.status}")

credentials = base64.b64encode(f"{TWILIO_ACCOUNT_SID}:{TWILIO_AUTH_TOKEN}".encode()).decode()
sms_body = f"TY AI OS REMINDER: {reminder_type} guardian check-in due. {days_remaining} days remaining. Check your email for instructions."
sms_data = urllib.parse.urlencode({
    "From": TWILIO_PHONE_NUMBER,
    "To": GUARDIAN_PHONE_NUMBER,
    "Body": sms_body
}).encode()
sms_req = urllib.request.Request(
    f"https://api.twilio.com/2010-04-01/Accounts/{TWILIO_ACCOUNT_SID}/Messages.json",
    data=sms_data,
    headers={
        "Authorization": f"Basic {credentials}",
        "Content-Type": "application/x-www-form-urlencoded"
    }
)
with urllib.request.urlopen(sms_req) as res:
    print(f"SMS sent: {res.status}")

print(f"Reminder complete: {reminder_type} sent to guardian.")