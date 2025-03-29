# arithmeticpialagoasm

# Gaining access to Shared Folders in Virtualbox (Ubuntu)
1. In the VM's screen, go to Devices tab > Shared Folders > Shared Folders Settings
2. Click the blue folder icon with plus sign
3. Set the 'Folder Path' Directory wherever you want
4. Folder Name
5. Enable 'Auto-mount' and 'Make Permanent'
6. Go to terminal and write 'sudo adduser $USER vboxsf'. You also have to enter your password afterwards
7. Restart Ubuntu
8. Once you have access, you can extract the files from this repository into your main PC's shared folder

# Opening the assembly code
1. Extract the files into your Ubuntu's desktop or anywhere else. Just make sure the terminal can access that directory.
2. Open up terminal and use the `cd` to navigate through directory
3. once you're in the directory that contains the files, enter `./arithpialago` and you'll run the asm.
