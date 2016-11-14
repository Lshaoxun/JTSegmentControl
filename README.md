# JTSegmentControl
自定义SegmentControl，可以选择红点、动态调节segment宽度，以及滚动。

## Display 
![](https://github.com/guangzhouxia/JTSegmentControl/raw/master/screenShot/display1.gif)
![](https://github.com/guangzhouxia/JTSegmentControl/raw/master/screenShot/display2.gif)

## Usage
#### Simple init JTSegmentControl
```Swift
        var frame = CGRect(x: 10.0, y: 130.0, width: self.view.bounds.size.width - 20.0, height: 44.0)
        let segmentControl = JTSegmentControl(frame: frame)
        segmentControl.delegate = self
        segmentControl.items = ["first", "second", "third", "fouth"]
        segmentControl.showBridge(show: true, index: 1)
        segmentControl.autoScrollWhenIndexChange = false
        view.addSubview(segmentControl)

```
##### Width is divide equally . This is have bridge and not scrolling when index changed.(宽度根据bounds进行平分，展示红点，选择item的时候不自动调整位置)

#### Init JTSegmentControl,auto to set itemView's width in scrollView, scrolling when index changed.（在一个ScrollView里，根据内容自动调整每个item的宽度，同时，选择item的时候自动调整它的位置。）
```Swift
        frame = CGRect(x: 10.0, y: 250.0, width: self.view.bounds.size.width - 20.0, height: 44.0)
        let autoWidthControl = JTSegmentControl(frame: frame)
        autoWidthControl.delegate = self
        autoWidthControl.items = ["first", "second", "third", "fouth", "fifth", "sixth", "seventh", "eighth"]
        autoWidthControl.selectedIndex = 1
        autoWidthControl.autoAdjustWidth = true
        autoWidthControl.bounces = true
        view.addSubview(autoWidthControl)
```
##### JTSegmentControl Delegate
```Swift
func didSelected(segement: JTSegmentControl, index: Int)
```
