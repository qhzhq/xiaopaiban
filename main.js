const { app, BrowserWindow, Menu, shell } = require('electron')

function createWindow() {
    const win = new BrowserWindow({
        width: 1024,
        height: 768,
        minWidth: 680,
        minHeight: 500,
        // macOS 原生风格
        titleBarStyle: 'hiddenInset',
        trafficLightPosition: { x: 12, y: 12 },
        vibrancy: 'window',
        visualEffectState: 'active',
        backgroundColor: '#f5f5f7',
        show: false,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            spellcheck: false
        }
    })

    win.loadFile('index.html')

    // 窗口准备好后再显示，避免白屏
    win.once('ready-to-show', () => {
        win.show()
    })

    // macOS 极简菜单：编辑功能 + 软件名 + 关于软件
    const template = [
        {
            label: '编辑',
            submenu: [
                { label: '撤销', accelerator: 'Cmd+Z', role: 'undo' },
                { label: '重做', accelerator: 'Shift+Cmd+Z', role: 'redo' },
                { type: 'separator' },
                { label: '剪切', accelerator: 'Cmd+X', role: 'cut' },
                { label: '复制', accelerator: 'Cmd+C', role: 'copy' },
                { label: '粘贴', accelerator: 'Cmd+V', role: 'paste' },
                { label: '全选', accelerator: 'Cmd+A', role: 'selectAll' },
                { label: '关于',
                    click: () => {
                        const { dialog } = require('electron')
                        dialog.showMessageBox(win, {
                            type: 'info',
                            title: '关于 一键排版',
                            message: '一键排版',
                            detail: '作者：静候美好\n hulian.pro',
                            buttons: ['访问网站', '确定'],
                            defaultId: 1
                        }).then(({ response }) => {
                            if (response === 0) {
                                shell.openExternal('http://hulian.pro')
                            }
                        })
                    }
                },
                { type: 'separator' },
                { label: '退出', accelerator: 'Cmd+Q', role: 'quit' }
            ]
        },
    ]
    Menu.setApplicationMenu(Menu.buildFromTemplate(template))

    // 注册全局快捷键 Cmd+G
    win.webContents.on('before-input-event', (event, input) => {
        if (input.key === 'g' && input.meta && input.type === 'keyDown') {
            win.webContents.executeJavaScript('run()')
            event.preventDefault()
        }
    })
}

app.whenReady().then(() => {
    createWindow()

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow()
        }
    })
})

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit()
    }
})
