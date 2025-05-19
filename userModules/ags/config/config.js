const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const audio = await Service.import("audio")
const systemtray = await Service.import("systemtray")

App.addIcons(`${App.configDir}/assets`)

const date = Variable("", {
  poll: [1000, 'date "+%H:%M:%S %b %d"'],
})


const workSpaceIcons = {
  1: "e",
  2: "t",
  3: "r",
  4: "m",
  5: "o",
}

function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start)
}

const Workspaces = () => range(Object.keys(workSpaceIcons).length).map(i => Widget.Button({
  attribute: i,
  on_clicked: () => hyprland.messageAsync(`dispatch workspace ${i}`),
  label: workSpaceIcons[i],
  setup: self => self.hook(hyprland, () => {
    self.toggleClassName("active", hyprland.active.workspace.id === i)
  }),
}))

const WorkspaceDisplay = () => Widget.Box({
  class_name: "workspaces",
  children: Workspaces()
})

function Notification() {
  const popups = notifications.bind("popups")
  return Widget.Box({
    class_name: "notification",
    visible: popups.as(p => p.length > 0),
    children: [
      Widget.Icon({
        size: 18,
        icon: "preferences-system-notifications-symbolic"
      }),
      Widget.Label({
        label: popups.as(p => p[0]?.summary || ""),
      }),
    ],
  })
}

function Clock() {
  return Widget.Label({
    class_name: "clock",
    label: date.bind(),
  })
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  }

  function getIcon() {
    const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
      threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${icons[icon]}-symbolic`
  }

  function getVolume() {
    return `${Math.round(audio.speaker.is_muted ? 0 : (audio.speaker.volume * 100))}%`
  }

  const icon = Widget.Icon({
    size: 18,
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  })

  const value = Widget.Label({
    label: Utils.watch(getVolume(), audio.speaker, getVolume),
  })

  return Widget.Box({
    vpack: "center",
    class_name: "volume-section",
    spacing: 5,
    children: [icon, value],
  })
}


function SysTray() {
  const items = systemtray.bind("items")
    .as(items => items.map(item => Widget.Button({
      child: Widget.Icon({ class_name: "widget_icon", icon: item.bind("icon"), size: 18 }),
      on_primary_click: (_, event) => item.activate(event),
      on_secondary_click: (_, event) => item.openMenu(event),
      tooltip_markup: item.bind("tooltip_markup"),
    })))

  return Widget.Box({
    class_name: "systray",
    children: items,
  })
}


// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 0,
    children: [
      WorkspaceDisplay(),
    ],
  })
}

function Center() {
  return Widget.CenterBox({
    class_name: "clock-box",
    vpack: "center",
    spacing: 2,
    center_widget: Clock()
  })
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 5,
    children: [
      Notification(),
      Volume(),
      SysTray(),
    ],
  })
}

function Bar(monitor = 0) {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    margins: [1, 10, 0, 10],
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  })
}

App.config({
  style: "./style.css",
  windows: [Bar()],
})

export { }
