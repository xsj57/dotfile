-- =============================================
-- 基于 Bundle ID 的自动输入法切换（完整版）
-- =============================================

-- 输入法定义
local inputMethods = {
	english = "com.apple.keylayout.ABC",
	chinese = "com.apple.inputmethod.SCIM.ITABC",
	traditional = "com.apple.inputmethod.TCIM.Pinyin",
	japanese = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
}

-- 记忆每个应用的输入法
local appInputMethodMemory = {}
local lastApp = nil
local lastBundleID = nil

-- =============================================
-- 工具函数
-- =============================================

-- 获取当前输入法
local function getCurrentInputMethod()
	local handle = io.popen("/opt/homebrew/bin/im-select")
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result:gsub("^%s*(.-)%s*$", "%1")
	end
	return nil
end

-- 设置输入法
local function setInputMethod(method)
	if method and method ~= "" then
		hs.execute("/opt/homebrew/bin/im-select " .. method)
	end
end

-- 显示通知
local function showNotification(text, duration)
	hs.alert.show(text, duration or 1)
end

-- =============================================
-- Bundle ID 配置
-- =============================================

local bundleInputMethod = {
	-- ===== 终端工具 =====
	["com.apple.Terminal"] = inputMethods.english,
	["com.mitchellh.ghostty"] = inputMethods.english,

	-- ===== 代码编辑器 / IDE =====
	["com.microsoft.VSCode"] = inputMethods.english,
	["com.microsoft.VSCodeInsiders"] = inputMethods.english,
	["com.visualstudio.code.oss"] = inputMethods.english,
	["com.todesktop.230313mzl4w4u92"] = inputMethods.english, -- Cursor
	["com.apple.dt.Xcode"] = inputMethods.english,
	["com.sublimetext.4"] = inputMethods.english,
	["com.sublimetext.3"] = inputMethods.english,
	["com.github.atom"] = inputMethods.english,
	["com.jetbrains.intellij"] = inputMethods.english,
	["com.jetbrains.intellij.ce"] = inputMethods.english,
	["com.jetbrains.pycharm"] = inputMethods.english,
	["com.jetbrains.pycharm.ce"] = inputMethods.english,
	["com.jetbrains.webstorm"] = inputMethods.english,
	["com.jetbrains.goland"] = inputMethods.english,
	["com.jetbrains.datagrip"] = inputMethods.english,
	["com.jetbrains.rider"] = inputMethods.english,
	["com.jetbrains.CLion"] = inputMethods.english,
	["com.jetbrains.PhpStorm"] = inputMethods.english,
	["com.jetbrains.rubymine"] = inputMethods.english,
	["com.jetbrains.AppCode"] = inputMethods.english,
	["com.google.android.studio"] = inputMethods.english,

	-- ===== 开发工具 =====
	-- ["com.docker.docker"] = inputMethods.english,
	-- ["com.electron.dockerdesktop"] = inputMethods.english,
	-- ["com.github.GitHubClient"] = inputMethods.english,
	-- ["com.github.desktop"] = inputMethods.english,
	-- ["com.sourcetreeapp.SourceTree"] = inputMethods.english,
	-- ["com.tinyapp.TablePlus"] = inputMethods.english,
	-- ["com.sequelpro.SequelPro"] = inputMethods.english,
	-- ["com.oracle.java.JavaControlPanel"] = inputMethods.english,
	-- ["com.postmanlabs.mac"] = inputMethods.english,
	-- ["com.paw.PAW"] = inputMethods.english,
	-- ["com.insomnia.app"] = inputMethods.english,
	-- ["com.luckymarmot.Paw"] = inputMethods.english,

	-- ===== 聊天软件 =====
	["com.tencent.xinWeChat"] = inputMethods.chinese,
	["com.tencent.qq"] = inputMethods.chinese,
	-- ["com.tencent.mqq"] = inputMethods.chinese,
	-- ["com.tencent.QQMusicMac"] = inputMethods.chinese,
	["com.alibaba.DingTalkMac"] = inputMethods.chinese,
	-- ["com.electron.lark"] = inputMethods.chinese,  -- 飞书
	-- ["com.bytedance.Feishu"] = inputMethods.chinese,
	-- ["com.bytedance.Lark"] = inputMethods.chinese,
	-- ["com.facebook.archon.Messenger"] = inputMethods.chinese,
	-- ["com.tdesktop.Telegram"] = inputMethods.chinese,
	-- ["ru.keepcoder.Telegram"] = inputMethods.chinese,
	-- ["com.apple.MobileSMS"] = inputMethods.chinese,  -- Messages
	-- ["com.microsoft.teams"] = inputMethods.chinese,
	-- ["com.microsoft.teams2"] = inputMethods.chinese,
	-- ["com.slack.Slack"] = inputMethods.english,
	-- ["com.discordapp.Discord"] = inputMethods.english,

	-- ===== 笔记/文档 =====
	-- ["notion.id"] = inputMethods.chinese,
	-- ["md.obsidian"] = inputMethods.chinese,
	-- ["com.electron.typora"] = inputMethods.chinese,
	-- ["abnerworks.Typora"] = inputMethods.chinese,
	-- ["com.microsoft.Word"] = inputMethods.chinese,
	-- ["com.apple.iWork.Pages"] = inputMethods.chinese,
	-- ["com.apple.Notes"] = inputMethods.chinese,
	-- ["com.evernote.Evernote"] = inputMethods.chinese,
	-- ["com.yinxiang.Mac"] = inputMethods.chinese,  -- 印象笔记
	-- ["com.onenotetool.OneNoteImporter"] = inputMethods.chinese,
	-- ["com.microsoft.onenote.mac"] = inputMethods.chinese,
	-- ["com.readdle.ReaddleDocsIPad"] = inputMethods.chinese,
	-- ["com.craftdocs.craft"] = inputMethods.chinese,
	-- ["com.electron.logseq"] = inputMethods.chinese,
	-- ["com.bohemiancoding.sketch3"] = inputMethods.english,

	-- ===== 浏览器（保持当前） =====
	-- ["com.apple.Safari"] = "keep",
	-- ["com.google.Chrome"] = "keep",
	-- ["com.google.Chrome.canary"] = "keep",

	-- ===== 系统工具 =====
	-- ["com.apple.finder"] = inputMethods.english,
	-- ["com.apple.systempreferences"] = inputMethods.english,
	-- ["com.apple.systemsettings"] = inputMethods.english,
	-- ["com.apple.ActivityMonitor"] = inputMethods.english,
	-- ["com.apple.Console"] = inputMethods.english,
	-- ["com.apple.DiskUtility"] = inputMethods.english,

	-- ===== 邮件 =====
	-- ["com.apple.mail"] = inputMethods.chinese,
	-- ["com.microsoft.Outlook"] = inputMethods.chinese,
	-- ["com.readdle.smartemail-Mac"] = inputMethods.chinese,
	-- ["com.google.Gmail"] = inputMethods.chinese,

	-- ===== 音视频 =====
	-- ["com.apple.QuickTimePlayerX"] = inputMethods.english,
	-- ["com.colliderli.iina"] = inputMethods.english,
	-- ["org.videolan.vlc"] = inputMethods.english,
	-- ["com.apple.Music"] = inputMethods.english,
	-- ["com.spotify.client"] = inputMethods.english,
	-- ["com.netease.163music"] = inputMethods.chinese,

	-- ===== 其他工具 =====
	-- ["com.raycast.macos"] = inputMethods.english,
	-- ["com.agiletortoise.Drafts-OSX"] = inputMethods.chinese,
	-- ["com.tapbots.Ivory"] = inputMethods.chinese,  -- Mastodon 客户端
	-- ["com.redis.Redis-Desktop-Manager"] = inputMethods.english,
	-- ["org.mozilla.thunderbird"] = inputMethods.chinese,
}

-- =============================================
-- 应用切换监听
-- =============================================

local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
	if eventType == hs.application.watcher.activated then
		local bundleID = appObject:bundleID()

		-- 调试输出（可以注释掉）
		-- print(string.format("App: %s, Bundle ID: %s", appName, bundleID))

		-- 保存上一个应用的输入法状态
		if lastBundleID and lastBundleID ~= bundleID then
			local currentMethod = getCurrentInputMethod()
			if currentMethod then
				appInputMethodMemory[lastBundleID] = currentMethod
			end
		end

		-- 获取目标输入法
		local targetMethod = bundleInputMethod[bundleID]

		if targetMethod == "keep" then
			-- 保持当前输入法不变
			-- print("Keeping current input method for " .. appName)
		elseif targetMethod then
			-- 使用预设的输入法
			setInputMethod(targetMethod)
			-- print("Setting input method to " .. targetMethod .. " for " .. appName)
		elseif appInputMethodMemory[bundleID] then
			-- 恢复之前记忆的输入法
			setInputMethod(appInputMethodMemory[bundleID])
			-- print("Restoring input method for " .. appName)
		end

		lastApp = appName
		lastBundleID = bundleID
	end
end)

-- 启动监听
appWatcher:start()

-- =============================================
-- 快捷键设置
-- =============================================

-- 手动切换输入法
hs.hotkey.bind({ "cmd", "shift" }, "1", function()
	setInputMethod(inputMethods.english)
	showNotification("🇺🇸 English")
end)

hs.hotkey.bind({ "cmd", "shift" }, "2", function()
	setInputMethod(inputMethods.chinese)
	showNotification("🇨🇳 简体中文")
end)

hs.hotkey.bind({ "cmd", "shift" }, "3", function()
	setInputMethod(inputMethods.traditional)
	showNotification("🇹🇼 繁體中文")
end)

hs.hotkey.bind({ "cmd", "shift" }, "4", function()
	setInputMethod(inputMethods.japanese)
	showNotification("🇯🇵 日本語")
end)

-- 显示当前应用信息（调试用）
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "I", function()
	local app = hs.application.frontmostApplication()
	local bundleID = app:bundleID()
	local currentIM = getCurrentInputMethod()

	local info = string.format(
		"应用名称: %s\nBundle ID: %s\n当前输入法: %s\n预设: %s",
		app:name(),
		bundleID,
		currentIM or "Unknown",
		bundleInputMethod[bundleID] or "无预设"
	)

	hs.alert.show(info, 3)

	-- 同时输出到控制台
	print("=====================================")
	print(info)
	print("=====================================")

	-- 复制 Bundle ID 到剪贴板
	hs.pasteboard.setContents(bundleID)
	print("Bundle ID 已复制到剪贴板")
end)

-- 临时禁用/启用自动切换
local autoSwitchEnabled = true
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "T", function()
	autoSwitchEnabled = not autoSwitchEnabled
	if autoSwitchEnabled then
		appWatcher:start()
		showNotification("✅ 自动切换已启用", 2)
	else
		appWatcher:stop()
		showNotification("⏸ 自动切换已暂停", 2)
	end
end)

-- 清除记忆的输入法
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "C", function()
	appInputMethodMemory = {}
	showNotification("🗑 已清除输入法记忆", 1.5)
end)

-- 重新加载配置
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	showNotification("🔄 重新加载配置...")
	hs.reload()
end)

-- =============================================
-- 初始化
-- =============================================

-- 检查 im-select 是否存在
local imSelectPath = "/opt/homebrew/bin/im-select"
if not hs.fs.attributes(imSelectPath) then
	hs.alert.show("⚠️ 未找到 im-select，请先安装", 5)
	print("请运行: curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh")
else
	showNotification("✅ Hammerspoon 输入法自动切换已启动", 2)
end

-- 在控制台显示快捷键帮助
print([[
=====================================
输入法自动切换 - 快捷键帮助
=====================================
Cmd+Shift+1: 切换到英文
Cmd+Shift+2: 切换到简体中文
Cmd+Shift+3: 切换到繁体中文
Cmd+Shift+4: 切换到日语
Cmd+Alt+Ctrl+I: 显示当前应用信息
Cmd+Alt+Ctrl+T: 暂停/恢复自动切换
Cmd+Alt+Ctrl+C: 清除输入法记忆
Cmd+Alt+Ctrl+R: 重新加载配置
=====================================
]])
