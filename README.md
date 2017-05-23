"Hi" iOS客户端项目介绍
--
</br>


#### APP 介绍:
              "Hi"是一款社交类app,一款用来供用户分享自己平时在淘宝等购物网站上看到的有趣物品的app.
              用户可以在发表状态时上传宝贝的链接, 这样别人在查看时就能直接在手机淘宝上,或应用内看到
              所分享的有趣物品.当然,用户也可以直接将"Hi"当作一款纯粹的社交app,用来分享日常生活与心情.
              "Hi" 目前已集成登录注册,即时通讯,发表状态等功能.未来也将加入更多功能.
              
 </br>
 </br>
 
> App 中所用到的技术:

#### 该项目的后台服务器基于Bmob 即时通讯功能基于融云

* 整体架构基于MVC 模式
* 支持手机 + 验证码注册登录 以及邮箱或手机号注册登录
* UITabBarController UInavigationController 父子控制器搭建项目UI结构
* 项目中运用各种自定义的navigationBar 以及不同界面中pop 和push问题的解决
* 需要请求数据的地方进行了网络判断 增加用户体验
* 应用间通信
* 第三方分享 支持分享URL
* 应用到刷新控件 HUD控件 以及自定义的ActionSheet
* 集成即时通讯功能(IM) 
* 应用FMDB 进行本地缓存
* 应用Masonry 进行自动布局
* 支持更换昵称和签名 更换头像 和更换背景 支持将网络图片保存到本地相册等功能
* 第三方服务器的建表和查询
* 聊天功能中集成录音 定位等功能
* 应用YYText 让用户昵称响应点击事件
* 应用了[cocoapods](https://github.com/CocoaPods/CocoaPods) 这个类库管理工具
* 应用了很多优秀的第三方库

</br>
</br>

> TODO: 

* 集成本地通知 和远程推送
* 完善私聊功能
* 解决个别页面的交互问题
* 运用软件检测App Crash以及内存泄漏等情况
* 申请开发者账号

</br>
</br>

> 项目过程中遇到的几个问题:
* 在某个页面push出来再pop出去的时候,程序会Crash 最后发现是由于用weak 修饰的一个tableView 
  被提前释放 导致程序不走dealloc方法 造成内存泄漏 解决办法:将weak 修饰符 改为strong

* 偶发的Bug: 当快速滑动首页的tableView时 任意点击进入一条状态的评论页面 会导致程序crash
  通过断点调试发现 是由于第三方服务器的响应速度有限 在快速滑动页面时 服务器返回数据的速度跟不上
  返回的数据为空 造成数据越界 导致程序奔溃
  解决办法是,做容错处理,当返回的数据为空时 先return 并再次向服务器请求数据

* 从一个界面push到一个界面,再从当前界面push到另一个界面 有可能会导致程序奔溃 或者push出来的页面在
  上一个页面出现. 解决办法: 在push前先判断当前进行的push的navigationController 的topViewController
  是否为当前页面 如果是用当前的navi push 如果不是 用另外页面的navi 进行push

</br>
</br>
             
> APP 截图:

![Alt text](https://bmob-cdn-10856.b0.upaiyun.com/2017/05/23/92a91236360d445ca0d1857e22b6a155.jpg)
![Alt text](https://bmob-cdn-10856.b0.upaiyun.com/2017/05/23/b287881250944bfd9aa0a26311fb1e13.jpg)
![Alt text](https://bmob-cdn-10856.b0.upaiyun.com/2017/05/23/f1939f9f8e5741919042264b3a58d399.jpg)

> 该项目所用到的部分优秀的第三方库
</br>

* [AFNetWorking](https://github.com/AFNetworking/AFNetworking)网络请求
* [SDWebImage](https://github.com/rs/SDWebImage)网络图片加载
* [Masonry](https://github.com/SnapKit/Masonry)自动布局
* [MJRefresh](https://github.com/CoderMJLee/MJRefresh)下拉刷新上拉加载控件
* [YYText](https://github.com/ibireme/YYText)富文本
* [Masonry](https://github.com/SnapKit/Masonry)自动布局
* [FMDB](https://github.com/ccgus/fmdb)对SQLite进行封装的本地存储库
...

</br>

> 感谢各位写出优秀框架的coder对开源社区做出的贡献
                      
  
