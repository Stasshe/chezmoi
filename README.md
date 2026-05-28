run following code to install dependencies:

```bash
chmod +x init1.sh
chmod +x init2.sh
./init1.sh
```

when you finish to login the gh, run the following code to install the rest of dependencies:
```bash
./init2.sh
```


```powershell
wsl --set-default Ubuntu
```



```json
{
  "commandline": "wsl.exe -d Ubuntu --cd ~ --exec zsh -i",
  "guid": "{c45b8388-031c-5783-bcb8-06ec821d49c2}", // This is a randomly generated GUID. You can generate a new one using `New-Guid` in PowerShell.
  "hidden": false,
  "name": "Ubuntu zsh"
}
```