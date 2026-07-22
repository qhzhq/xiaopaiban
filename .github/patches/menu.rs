// Menu functionality is only used on macOS; the module is gated in app/mod.rs.
use crate::app::window::open_additional_window_safe;
use tauri::menu::{AboutMetadata, Menu, MenuItem, PredefinedMenuItem, Submenu};
use tauri::{AppHandle, Manager, Wry};
use tauri_plugin_opener::OpenerExt;

pub fn set_app_menu(
    app: &AppHandle<Wry>,
    allow_multi_window: bool,
    enable_find: bool,
) -> tauri::Result<()> {
    let pake_version = env!("CARGO_PKG_VERSION");
    let pake_menu_item_title = format!("Built with Pake V{}", pake_version);

    let window_submenu = window_menu(app)?;

    let menu = Menu::with_items(
        app,
        &[
            &app_menu(app)?,
            &file_menu(app, allow_multi_window)?,
            &edit_menu(app, enable_find)?,
            &view_menu(app)?,
            &navigation_menu(app)?,
            &window_submenu,
            &help_menu(app, &pake_menu_item_title)?,
        ],
    )?;

    app.set_menu(menu)?;

    // AppKit injects Move & Resize, Fill, Center, Full Screen Tile, and
    // window-cycling once the submenu is registered as the windows menu.
    window_submenu.set_as_windows_menu_for_nsapp()?;

    Ok(())
}

fn app_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let app_menu = Submenu::new(app, "小排版", true)?;
    let about_metadata = AboutMetadata::default();
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

fn file_menu(app: &AppHandle<Wry>, allow_multi_window: bool) -> tauri::Result<Submenu<Wry>> {
    let file_menu = Submenu::new(app, "文件", true)?;
    if allow_multi_window {
        file_menu.append(&MenuItem::with_id(
            app,
            "new_window",
            "新建窗口",
            true,
            Some("CmdOrCtrl+N"),
        )?)?;
        file_menu.append(&PredefinedMenuItem::separator(app)?)?;
    }
    file_menu.append(&PredefinedMenuItem::close_window(app, None)?)?;
    file_menu.append(&PredefinedMenuItem::separator(app)?)?;
    file_menu.append(&MenuItem::with_id(
        app,
        "clear_cache_restart",
        "清除缓存并重启",
        true,
        Some("CmdOrCtrl+Shift+Backspace"),
    )?)?;
    Ok(file_menu)
}

fn edit_menu(app: &AppHandle<Wry>, enable_find: bool) -> tauri::Result<Submenu<Wry>> {
    let edit_menu = Submenu::new(app, "编辑", true)?;
    edit_menu.append(&PredefinedMenuItem::undo(app, Some("撤销"))?)?;
    edit_menu.append(&PredefinedMenuItem::redo(app, Some("重做"))?)?;
    edit_menu.append(&PredefinedMenuItem::separator(app)?)?;
    edit_menu.append(&PredefinedMenuItem::cut(app, Some("剪切"))?)?;
    edit_menu.append(&PredefinedMenuItem::copy(app, Some("复制"))?)?;
    edit_menu.append(&PredefinedMenuItem::paste(app, Some("粘贴"))?)?;
    edit_menu.append(&MenuItem::with_id(
        app,
        "paste_and_match_style",
        "粘贴并匹配样式",
        true,
        Some("CmdOrCtrl+Shift+Option+V"),
    )?)?;
    edit_menu.append(&PredefinedMenuItem::select_all(app, Some("全选"))?)?;
    edit_menu.append(&PredefinedMenuItem::separator(app)?)?;
    if enable_find {
        edit_menu.append(&MenuItem::with_id(
            app,
            "find",
            "查找",
            true,
            Some("CmdOrCtrl+F"),
        )?)?;
        edit_menu.append(&MenuItem::with_id(
            app,
            "find_next",
            "查找下一个",
            true,
            Some("CmdOrCtrl+G"),
        )?)?;
        edit_menu.append(&MenuItem::with_id(
            app,
            "find_previous",
            "查找上一个",
            true,
            Some("CmdOrCtrl+Shift+G"),
        )?)?;
        edit_menu.append(&PredefinedMenuItem::separator(app)?)?;
    }
    edit_menu.append(&MenuItem::with_id(
        app,
        "copy_url",
        "复制链接",
        true,
        Some("CmdOrCtrl+L"),
    )?)?;
    Ok(edit_menu)
}

fn view_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let view_menu = Submenu::new(app, "视图", true)?;
    view_menu.append(&MenuItem::with_id(
        app,
        "reload",
        "重新加载",
        true,
        Some("CmdOrCtrl+R"),
    )?)?;
    view_menu.append(&PredefinedMenuItem::separator(app)?)?;
    view_menu.append(&MenuItem::with_id(
        app,
        "zoom_in",
        "放大",
        true,
        Some("CmdOrCtrl+="),
    )?)?;
    view_menu.append(&MenuItem::with_id(
        app,
        "zoom_out",
        "缩小",
        true,
        Some("CmdOrCtrl+-"),
    )?)?;
    view_menu.append(&MenuItem::with_id(
        app,
        "zoom_reset",
        "原始大小",
        true,
        Some("CmdOrCtrl+0"),
    )?)?;
    view_menu.append(&PredefinedMenuItem::separator(app)?)?;
    view_menu.append(&PredefinedMenuItem::fullscreen(app, None)?)?;
    view_menu.append(&PredefinedMenuItem::separator(app)?)?;
    view_menu.append(&MenuItem::with_id(
        app,
        "toggle_devtools",
        "Toggle Developer Tools",
        cfg!(debug_assertions),
        Some("CmdOrCtrl+Option+I"),
    )?)?;
    Ok(view_menu)
}

fn navigation_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let navigation_menu = Submenu::new(app, "导航", true)?;
    navigation_menu.append(&MenuItem::with_id(
        app,
        "go_back",
        "后退",
        true,
        Some("CmdOrCtrl+["),
    )?)?;
    navigation_menu.append(&MenuItem::with_id(
        app,
        "go_forward",
        "前进",
        true,
        Some("CmdOrCtrl+]"),
    )?)?;
    navigation_menu.append(&MenuItem::with_id(
        app,
        "go_home",
        "首页",
        true,
        Some("CmdOrCtrl+Shift+H"),
    )?)?;
    Ok(navigation_menu)
}

fn window_menu(app: &AppHandle<Wry>) -> tauri::Result<Submenu<Wry>> {
    let window_menu = Submenu::new(app, "窗口", true)?;
    window_menu.append(&PredefinedMenuItem::minimize(app, None)?)?;
    window_menu.append(&PredefinedMenuItem::maximize(app, None)?)?;
    window_menu.append(&PredefinedMenuItem::separator(app)?)?;
    window_menu.append(&MenuItem::with_id(
        app,
        "always_on_top",
        "窗口置顶",
        true,
        None::<&str>,
    )?)?;
    window_menu.append(&PredefinedMenuItem::separator(app)?)?;
    window_menu.append(&PredefinedMenuItem::close_window(app, None)?)?;
    Ok(window_menu)
}

fn help_menu(app: &AppHandle<Wry>, title: &str) -> tauri::Result<Submenu<Wry>> {
    let help_menu = Submenu::new(app, "帮助", true)?;
    let github_item = MenuItem::with_id(app, "pake_github_link", title, true, None::<&str>)?;
    help_menu.append(&github_item)?;
    Ok(help_menu)
}

pub fn handle_menu_click(app_handle: &AppHandle, id: &str) {
    match id {
        "new_window" => {
            open_additional_window_safe(app_handle);
        }
        "pake_github_link" => {
            let _ = app_handle
                .opener()
                .open_url("https://github.com/tw93/Pake", None::<&str>);
        }
        "reload" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.location.reload()");
            }
        }
        "toggle_devtools" => {
            #[cfg(debug_assertions)] // Only allow in debug builds
            if let Some(window) = app_handle.get_webview_window("pake") {
                if window.is_devtools_open() {
                    window.close_devtools();
                } else {
                    window.open_devtools();
                }
            }
        }
        "zoom_in" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("zoomIn()");
            }
        }
        "zoom_out" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("zoomOut()");
            }
        }
        "zoom_reset" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("setZoom('100%')");
            }
        }
        "go_back" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.history.back()");
            }
        }
        "go_forward" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.history.forward()");
            }
        }
        "go_home" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.location.href = window.pakeConfig.url");
            }
        }
        "copy_url" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("navigator.clipboard.writeText(window.location.href)");
            }
        }
        "paste_and_match_style" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("triggerPasteAsPlainText()");
            }
        }
        "find" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.pakeFind?.open()");
            }
        }
        "find_next" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.pakeFind?.next()");
            }
        }
        "find_previous" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let _ = window.eval("window.pakeFind?.previous()");
            }
        }
        "clear_cache_restart" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                if window.clear_all_browsing_data().is_ok() {
                    app_handle.restart();
                }
            }
        }
        "always_on_top" => {
            if let Some(window) = app_handle.get_webview_window("pake") {
                let is_on_top = window.is_always_on_top().unwrap_or(false);
                let _ = window.set_always_on_top(!is_on_top);
            }
        }
        _ => {}
    }
}
