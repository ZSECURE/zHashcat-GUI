from flask import Flask, render_template, request
import os
import subprocess
from datetime import datetime

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Get the client name and hash mode from the form
        client_name = request.form.get('client_name')
        hash_mode = request.form.get('hash_mode')

        # Get the value of the usernames_present checkbox
        usernames_present = 'username_check' in request.form

        # Get the file from the form
        file = request.files['file']

        # Generate the file name based on the client name and the current date and time
        file_name = f'{client_name}-{datetime.now().strftime("%Y%m%d%H%M%S")}{os.path.splitext(file.filename)[1]}'

        # Save the file to a temporary location
        file.save(os.path.join('D:\\hashes\\tmp\\', file_name))

        # Run the server.py script with the user input as arguments. Can be any script 
        #subprocess.run(['python.exe', 'server.py', hash_mode, 'D:\\Hashes\\tmp\\' + file_name, client_name])
        if usernames_present:
            # If usernames are present, run this command
            subprocess.Popen(['powershell', 'c:\\zHashcat_with_Usernames_v0.1.ps1', hash_mode, 'D:\\Hashes\\tmp\\' + file_name, client_name])
        else:
            # If usernames are not present, run this command
            subprocess.Popen(['powershell', 'c:\\zHashcat_v0.1.ps1', hash_mode, 'D:\\Hashes\\tmp\\' + file_name, client_name])
        

    return render_template('index.html')

@app.route('/status', methods=['GET'])
def status():
    # Check if the screen session is running
    result = subprocess.run(['tasklist'], stdout=subprocess.PIPE)
    if 'hashcat.exe' in result.stdout.decode():
        return 'A process is running.'
    else:
        return 'No process is running.'

@app.route('/kill', methods=['POST'])
def kill():
    # Kill the hashcat.exe process
    #os.system('taskkill /f /im hashcat.exe')
    os.system('taskkill /f /im powershell.exe')
    return 'Process killed.'

if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0')