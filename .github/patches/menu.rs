// Menu functionality is only used on macOS; the module is gated in app/mod.rs.
use tauri::menu::{AboutMetadata, Menu, PredefinedMenuItem, Submenu};
use tauri::{AppHandle, Wry};

pub fn set_app_menu(
    app: &AppHandle<Wry>,
    _allow_multi_window: bool,
    _enable_find: bool,
) -> tauri::Result<()> {
    let menu = Menu::with_items(
        app,
        &[
            &app_menu(app)?,
            &edit_menu(app)?,
        ],
    )?;

    app.set_menu(menu)?;
    Ok(())
}

fn app_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let app_menu = Submenu::new(app, "小排版", true)?;
    let about_metadata = AboutMetadata {
        version: Some("1.5.4".to_string()),
        authors: Some(vec!["静候美好".to_string()]),
        comments: Some("hulian.pro".to_string()),
        ..Default::default()
    };
    app_menu.append(&PredefinedMenuItem::about(
        app,
        Some("关于 一键排版"),
        Some(about_metadata),
    )?)?;
    app_menu.append(&PredefinedMenuItem::separator(app)?)?;
    app_menu.append(&PredefinedMenuItem::services(app, None)?)?;
    app_menu.append(&PredefinedMenuItem::separator(app)?)?;
    app_menu.append(&PredefinedMenuItem::hide(app, Some("隐藏"))?)?;
    app_menu.append(&PredefinedMenuItem::hide_others(app, Some("隐藏其他"))?)?;
    app_menu.append(&PredefinedMenuItem::show_all(app, Some("显示全部"))?)?;
    app_menu.append(&PredefinedMenuItem::separator(app)?)?;
    app_menu.append(&PredefinedMenuItem::quit(app, Some("退出"))?)?;
    Ok(app_menu)
}

fn edit_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let edit_menu = Submenu::new(app, "编辑", true)?;
    edit_menu.append(&PredefinedMenuItem::undo(app, Some("撤销"))?)?;
    edit_menu.append(&PredefinedMenuItem::redo(app, Some("重做"))?)?;
    edit_menu.append(&PredefinedMenuItem::separator(app)?)?;
    edit_menu.append(&PredefinedMenuItem::cut(app, Some("剪切"))?)?;
    edit_menu.append(&PredefinedMenuItem::copy(app, Some("复制"))?)?;
    edit_menu.append(&PredefinedMenuItem::paste(app, Some("粘贴"))?)?;
    edit_menu.append(&PredefinedMenuItem::separator(app)?)?;
    edit_menu.append(&PredefinedMenuItem::select_all(app, Some("全选"))?)?;
    Ok(edit_menu)
}

pub fn handle_menu_click(_app_handle: &AppHandle, _id: &str) {
    // 所有菜单项均为系统预定义项，无需自定义处理
}
