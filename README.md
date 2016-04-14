# SlideMenuDemo
侧滑菜单的实现（主页向右滑动，露出下方菜单页）

原文链接：http://www.hangge.com/blog/cache/detail_1028.html

侧滑菜单是现在的APP上很常见的功能，其效果是在主界面用手指向右滑动，就可以将菜单展示出来，而主界面会被隐藏大部分，但是仍有左侧的一小部分同菜单一起展示。


代码讲解
（1）页面初始化完毕后我们会先把主页视图（MainViewController）添加进来，同时对其设置个拖动手势（UIPanGestureRecognizer）。
（2）当手指在屏幕从左向右滑动时，创建菜单视图（MenuViewController）并添加到页面最底部。同时主页视图会随着手指的移动做线性移动。
（3）手指离开后，根据主页视图的位置（是否滑动超过一半），程序自动将主页视图完全展开或收起。
（4）菜单完全展开时，手指点击主页突出的部分也会自动收起菜单。
（5）menuViewExpandedOffset属性是设置菜单展示出来后，主页面在左侧露出部分的宽度。
（6）currentState属性保存菜单的状态，同时监听它的didSet事件来设置主页面阴影（当菜单显示出来的时候，主页边框会添加阴影，这样有层次感，效果更好些。）


功能改进
如果只有左右滑动能调出菜单的话，会显得把菜单功能隐藏太深，可能用户使用半天还不知道有这个菜单。
所以通常除了滑动调出菜单，页面上也会提供个菜单按钮，一般放置在导航栏上。点击按钮同样可以打开，收起菜单。

