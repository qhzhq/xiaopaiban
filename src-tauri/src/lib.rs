use tauri::{
    menu::{MenuBuilder, MenuItemBuilder, SubmenuBuilder},
    Manager,
};

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .setup(|app| {
            // 创建菜单项
            let undo = MenuItemBuilder::with_id("undo", "撤销")
                .accelerator("CmdOrCtrl+Z")
                .build(app)?;
            let redo = MenuItemBuilder::with_id("redo", "重做")
                .accelerator("Shift+CmdOrCtrl+Z")
                .build(app)?;
            let cut = MenuItemBuilder::with_id("cut", "剪切")
                .accelerator("CmdOrCtrl+X")
                .build(app)?;
            let copy = MenuItemBuilder::with_id("copy", "复制")
                .accelerator("CmdOrCtrl+C")
                .build(app)?;
            let paste = MenuItemBuilder::with_id("paste", "粘贴")
                .accelerator("CmdOrCtrl+V")
                .build(app)?;
            let select_all = MenuItemBuilder::with_id("select_all", "全选")
                .accelerator("CmdOrCtrl+A")
                .build(app)?;
            let about = MenuItemBuilder::with_id("about", "关于")
                .build(app)?;
            let visit_website = MenuItemBuilder::with_id("visit_website", "访问网站")
                .build(app)?;
            let quit = MenuItemBuilder::with_id("quit", "退出")
                .accelerator("CmdOrCtrl+Q")
                .build(app)?;

            // 创建编辑子菜单
            let edit_menu = SubmenuBuilder::with_id(app, "edit", "编辑")
                .item(&undo)
                .item(&redo)
                .separator()
                .item(&cut)
                .item(&copy)
                .item(&paste)
                .item(&select_all)
                .separator()
                .item(&about)
                .item(&visit_website)
                .separator()
                .item(&quit)
                .build()?;

            // 创建主菜单
            let menu = MenuBuilder::new(app)
                .item(&edit_menu)
                .build()?;

            // 设置菜单
            app.set_menu(menu)?;

            // 获取主窗口并设置 macOS 特有样式
            let window = app.get_webview_window("main").unwrap();

            #[cfg(target_os = "macos")]
            {
                use tauri::WebviewWindowExt;
                // 设置交通灯按钮位置
                window.set_traffic_light_position(tauri::LogicalPosition::new(12.0, 12.0))?;
            }

            Ok(())
        })
        .on_menu_event(|app, event| {
            match event.id().as_ref() {
                "about" => {
                    let window = app.get_webview_window("main").unwrap();
                    // 使用 JavaScript 显示关于对话框
                    let js_code = r#"
                        alert('一键排版\n\n作者：静候美好\nhulian.pro');
                    "#;
                    let _ = window.eval(js_code);
                }
                "visit_website" => {
                    let window = app.get_webview_window("main").unwrap();
                    let _ = window.eval("window.open('http://hulian.pro', '_blank')");
                }
                "quit" => {
                    app.exit(0);
                }
                _ => {}
            }
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}