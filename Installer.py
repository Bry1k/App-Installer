import ctypes, os, sys, requests, subprocess
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget, QTabWidget, QPushButton, QGridLayout, QMessageBox
from PyQt5.QtCore import QTimer, Qt
from PyQt5.QtGui import QFont
import win32gui, win32con

hide = win32gui.GetForegroundWindow()
win32gui.ShowWindow(hide, win32con.SW_HIDE)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("App Installer")
        self.setGeometry(700, 200, 800, 700)
        self.setStyleSheet("background-color: black;")

        # Create a central widget and layout
        self.central_widget = QWidget()
        self.layout = QVBoxLayout(self.central_widget)
        self.setCentralWidget(self.central_widget)

        # Create title label but do not add it to the layout yet
        self.title_label = QLabel("App Installer")
        font = QFont()
        font.setPointSize(30)
        self.title_label.setFont(font)
        self.title_label.setStyleSheet("color: white;")
        self.title_label.setAlignment(Qt.AlignHCenter | Qt.AlignTop)

        # Create labels for displaying messages
        self.admin_label = QLabel(self)
        self.connection_label = QLabel(self)
        self.choco_label = QLabel(self)

        # Set font size to 30px and text color to white
        font = QFont()
        font.setPointSize(30)
        self.admin_label.setFont(font)
        self.admin_label.setStyleSheet("color: white;")
        self.connection_label.setFont(font)
        self.connection_label.setStyleSheet("color: white;")
        self.choco_label.setFont(font)
        self.choco_label.setStyleSheet("color: white;")

        # Add labels to the layout with reduced spacing
        self.layout.addWidget(self.admin_label)
        self.layout.addWidget(self.connection_label)
        self.layout.addWidget(self.choco_label)
        self.layout.setSpacing(10) 

        # Check for admin rights and update the label
        self.check_admin_rights()

        # Check for internet connection and update the label
        self.check_internet_connection()

        # Check for Chocolatey installation and update the label
        self.check_chocolatey()

        # Set a timer to clear the labels after 3 seconds
        QTimer.singleShot(3000, self.load_main_interface)

        # Ensure the Logs directory exists
        if not os.path.exists("Logs"):
            os.makedirs("Logs")

    def check_admin_rights(self):
        try:
            is_admin = os.getuid() == 0
        except AttributeError:
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0

        if is_admin:
            self.admin_label.setText("Admin rights detected.")
        else:
            self.admin_label.setText("No administrative rights detected.")

    def check_internet_connection(self):
        if self.is_connected():
            self.connection_label.setText("Internet connection is available.")
        else:
            self.connection_label.setText("No internet connection.\nPlease make sure you are connected to the internet.")

    def is_connected(self):
        try:
            requests.get("https://www.google.com", timeout=5)
            return True
        except requests.ConnectionError:
            return False

    def check_chocolatey(self):
        choco_path = os.path.join(os.getenv('ProgramData'), 'chocolatey', 'choco.exe')
        if os.path.exists(choco_path):
            self.choco_label.setText("Chocolatey exists.")
        else:
            self.choco_label.setText("Chocolatey isn't installed.\nRunning install script...")
            self.install_chocolatey()

    def install_chocolatey(self):
        subprocess.run(['powershell', '-ExecutionPolicy', 'Bypass', '-NoProfile', '-Command', 
                        'Invoke-WebRequest -Uri "https://community.chocolatey.org/install.ps1" -OutFile "install.ps1"; .\\install.ps1'], 
                       shell=True)
        subprocess.run(['call', os.path.join(os.getenv("ProgramData"), "chocolatey", "bin", "RefreshEnv.cmd")], 
                       shell=True)
        subprocess.run(['choco', 'feature', 'enable', '-n=allowGlobalConfirmation'], 
                       shell=True)

    def load_main_interface(self):
        self.admin_label.clear()
        self.connection_label.clear()
        self.choco_label.clear()

        # Add title label to the layout at the very top
        self.layout.insertWidget(0, self.title_label, alignment=Qt.AlignHCenter | Qt.AlignTop)

        # Create tabs
        self.tabs = QTabWidget()
        self.layout.addWidget(self.tabs)

        # Add tabs for different categories
        self.create_browser_tab()
        self.create_app_tab()
        self.create_util_tab()
        self.create_game_tab()
        self.create_dev_tab()

    def create_browser_tab(self):
        browser_tab = QWidget()
        layout = QGridLayout()

        # Add buttons for each browser with smaller white border
        layout.addWidget(QPushButton("Google Chrome", clicked=lambda: self.install_app("googlechrome"), styleSheet="color: white; border: 1px solid white;"), 0, 0)
        layout.addWidget(QPushButton("Brave", clicked=lambda: self.install_app("brave"), styleSheet="color: white; border: 1px solid white;"), 0, 1)
        layout.addWidget(QPushButton("Firefox", clicked=lambda: self.install_app("firefox"), styleSheet="color: white; border: 1px solid white;"), 1, 0)
        layout.addWidget(QPushButton("Vivaldi", clicked=lambda: self.install_app("vivaldi"), styleSheet="color: white; border: 1px solid white;"), 1, 1)

        browser_tab.setLayout(layout)
        self.tabs.addTab(browser_tab, "Browsers")

    def create_app_tab(self):
        app_tab = QWidget()
        layout = QGridLayout()

        # Add buttons for each app with smaller white border
        layout.addWidget(QPushButton("Discord", clicked=lambda: self.install_app("discord"), styleSheet="color: white; border: 1px solid white;"), 0, 0)
        layout.addWidget(QPushButton("Spotify", clicked=lambda: self.install_app("spotify"), styleSheet="color: white; border: 1px solid white;"), 0, 1)
        layout.addWidget(QPushButton("iTunes", clicked=lambda: self.install_app("itunes"), styleSheet="color: white; border: 1px solid white;"), 1, 0)

        app_tab.setLayout(layout)
        self.tabs.addTab(app_tab, "Apps")

    def create_util_tab(self):
        util_tab = QWidget()
        layout = QGridLayout()

        # Add buttons for each utility with smaller white border
        layout.addWidget(QPushButton("7zip", clicked=lambda: self.install_app("7zip"), styleSheet="color: white; border: 1px solid white;"), 0, 0)
        layout.addWidget(QPushButton("GPU-Z", clicked=lambda: self.install_app("gpu-z"), styleSheet="color: white; border: 1px solid white;"), 0, 1)
        layout.addWidget(QPushButton("HWINFO", clicked=lambda: self.install_app("hwinfo"), styleSheet="color: white; border: 1px solid white;"), 1, 0)
        layout.addWidget(QPushButton("OBS Studio", clicked=lambda: self.install_app("obs-studio"), styleSheet="color: white; border: 1px solid white;"), 1, 1)
        layout.addWidget(QPushButton("NanaZip", clicked=lambda: self.install_app("nanazip"), styleSheet="color: white; border: 1px solid white;"), 2, 0)
        layout.addWidget(QPushButton("Notepad++", clicked=lambda: self.install_app("notepadplusplus"), styleSheet="color: white; border: 1px solid white;"), 2, 1)

        util_tab.setLayout(layout)
        self.tabs.addTab(util_tab, "Utilities")

    def create_game_tab(self):
        game_tab = QWidget()
        layout = QGridLayout()

        # Add buttons for each game launcher with smaller white border
        layout.addWidget(QPushButton("Epic Games", clicked=lambda: self.install_app("epicgameslauncher"), styleSheet="color: white; border: 1px solid white;"), 0, 0)
        layout.addWidget(QPushButton("Steam", clicked=lambda: self.install_app("steam-client"), styleSheet="color: white; border: 1px solid white;"), 0, 1)
        layout.addWidget(QPushButton("Ubisoft Connect", clicked=lambda: self.install_app("ubisoft-connect"), styleSheet="color: white; border: 1px solid white;"), 1, 0)
        layout.addWidget(QPushButton("GOG Galaxy", clicked=lambda: self.install_app("goggalaxy"), styleSheet="color: white; border: 1px solid white;"), 1, 1)

        game_tab.setLayout(layout)
        self.tabs.addTab(game_tab, "Game Launchers")

    def create_dev_tab(self):
        dev_tab = QWidget()
        layout = QGridLayout()

        # Add buttons for each development tool with smaller white border
        layout.addWidget(QPushButton("Python", clicked=lambda: self.install_app("python"), styleSheet="color: white; border: 1px solid white;"), 0, 0)
        layout.addWidget(QPushButton("Git", clicked=lambda: self.install_app("git"), styleSheet="color: white; border: 1px solid white;"), 0, 1)
        layout.addWidget(QPushButton("Rust", clicked=lambda: self.install_app("rust"), styleSheet="color: white; border: 1px solid white;"), 1, 0)
        layout.addWidget(QPushButton("Golang", clicked=lambda: self.install_app("golang"), styleSheet="color: white; border: 1px solid white;"), 1, 1)
        layout.addWidget(QPushButton("Visual Studio Code", clicked=lambda: self.install_app("vscode"), styleSheet="color: white; border: 1px solid white;"), 2, 0)
        layout.addWidget(QPushButton("VSCodium", clicked=lambda: self.install_app("vscodium"), styleSheet="color: white; border: 1px solid white;"), 2, 1)

        dev_tab.setLayout(layout)
        self.tabs.addTab(dev_tab, "Development")

    def install_app(self, app_name):
        # Function to install the app using Chocolatey
        subprocess.run(['choco', 'install', app_name], shell=True)
        # Log the installed app
        with open("Logs/log.txt", "a") as log_file:
            log_file.write(f"Installed {app_name}\n")
        # Show message box after installation
        msg_box = QMessageBox(self)
        msg_box.setWindowTitle("Installation Complete")
        msg_box.setText(f"{app_name} has been installed successfully.")
        msg_box.setStyleSheet("QLabel{color: white;} QPushButton{color: white; border: 1px solid white;}")
        msg_box.exec_()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())