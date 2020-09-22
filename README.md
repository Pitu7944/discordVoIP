# discordVoIP
[![GitHub issues](https://img.shields.io/github/issues/Pitu7944/discordVoIP?style=for-the-badge)](https://github.com/Pitu7944/discordVoIP/issues)
discordVoIP is a **FiveM** script for using discord as voice in radios, phones and more.
It provides a simple api for adding job restricted channels, and more. 
Click the **wiki** button for documentation <3

## Installation

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa # When prompted press Enter to continue
sudo apt install python3.8 python3-venv tmux
mkdir ~/discordVoIP_Server
cd ~/discordVoIP_Server
git clone "https://github.com/Pitu7944/discordVoIP.git" ./
python3.8 -m venv env
```

## Usage

```bash
source ~/discordVoIP_Server/env/bin/activate
# right here you want to go to config.py and edit the fields according to the comments included in the file
tmux new-session -d -s discordVoIP_discordModule "python3.8 ~/discordVoIP_Server/discord_module.py"
tmux new-session -d -s discordVoIP_requestHandler "
python3.8 ~/discordVoIP_Server/requesthandler_module.py"
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
