import paramiko
import RPi.GPIO as GPIO
import time

# Raspberry Pi IP addresses
pi1_ip = "192.168.43.41"
pi2_ip = "192.168.43.89"

# GPIO pins for triggering
trigger_pin_pi1 = 17
trigger_pin_pi2 = 18

# SSH login credentials
username = "pi"
password = "your_password"

# Function to send trigger signal
def send_trigger_signal(pi_ip, trigger_pin):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(pi_ip, username=username, password=password)
    ssh.exec_command(f"python3 trigger.py {trigger_pin}")
    ssh.close()

# Main function
if __name__ == "__main__":
    # Initialize GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(trigger_pin_pi1, GPIO.OUT)
    GPIO.setup(trigger_pin_pi2, GPIO.OUT)

    # Send trigger signal to both Raspberry Pis simultaneously
    GPIO.output(trigger_pin_pi1, GPIO.HIGH)
    GPIO.output(trigger_pin_pi2, GPIO.HIGH)
    time.sleep(0.001)  # Adjust delay as needed for synchronization
    GPIO.output(trigger_pin_pi1, GPIO.LOW)
    GPIO.output(trigger_pin_pi2, GPIO.LOW)

    # Close GPIO
    GPIO.cleanup()








