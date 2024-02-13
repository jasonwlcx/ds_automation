import os

USERNAME = os.getenv("USERNAME")

# shutdown Design Space
def ds_shutdown():
    PROCESS = 'Cricut Design Space.exe'
    STATUS = 'running'
    CMD = r'taskkill /T /F /fi "IMAGENAME eq {}" /fi "STATUS eq {}" '.format(PROCESS, STATUS)
    os.system(CMD)

# delete design space cache from all locations
def ds_delete_cache(USERNAME):
    userName = str(USERNAME)
    pathToFolder = list()
    pathToFolder = ["C:\\Users\\" + userName + "\\.cricut-design-space",
                    "C:\\Users\\" + userName + "\\AppData\\Roaming\\Cricut Design Space"]
                    #"C:\\Users\\" + userName + "\\AppData\\Local\\Programs\\Cricut Design Space"]

    for path in pathToFolder:
        #print('"'+path+'"')
        try:
            print("---- Deleting Design Space Cache Folder: " + path)
            CMD = r'rd /s /q "' + str(path) + '"'
            os.system(CMD)
        except:
            print("---- Can't delete Design Space Cache Folder: " + path)

# call the defined functions
ds_shutdown()
ds_delete_cache(USERNAME)
