# 代码混淆压缩比，在0~7之间，默认为5,一般不下需要修改
-optimizationpasses 5
# 混淆时不使用大小写混合，混淆后的类名为小写
# windows下的同学还是加入这个选项吧(windows大小写不敏感)
-dontusemixedcaseclassnames
# 指定不去忽略非公共的库的类的成员
-dontskipnonpubliclibraryclasses
# 不做预检验，preverify是proguard的四个步骤之一
# Android不需要preverify，去掉这一步可以加快混淆速度
-dontpreverify
# 有了verbose这句话，混淆后就会生成映射文件
# 包含有类名->混淆后类名的映射关系
# 然后使用printmapping指定映射文件的名称
-verbose
# -printmapping priguardMapping.txt

# 指定混淆时采用的算法，后面的参数是一个过滤器
# 这个过滤器是谷歌推荐的算法，一般不改变
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-dontoptimize
-dontwarn dalvik.**
-ignorewarnings


#-applymapping mapping/mapping.txt

# 保留了继承自Activity、Application这些类的子类
# 因为这些子类有可能被外部调用
# 比如第一行就保证了所有Activity的子类不要被混淆
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class * extends org.sojex.finance.common.SafeAbstractPreference
-keep public class * extends org.sojex.finance.common.AbstractPreference
-keep public class com.android.vending.licensing.ILicensingService

# 如果有引用android-support-v4.jar包，可以添加下面这行
-keep public class com.null.test.ui.fragment.** {*;}
-keep public class * extends com.gkoudai.finance.mvvm.MvvmBaseViewModel
-keep public class * extends com.gkoudai.finance.mvvm.MvvmBaseModel
# 保留所有的本地native方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# 保留Activity中的方法参数是view的方法，
# 从而我们在layout里面编写onClick就不会影响
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

# 保留自定义控件(继承自View)不能被混淆
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(***);
    *** get* ();
}


-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留Parcelable序列化的类不能被混淆
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# 保留Serializable 序列化的类不被混淆
-keepclassmembers class * implements java.io.Serializable {
   static final long serialVersionUID;
   private static final java.io.ObjectStreamField[] serialPersistentFields;
   !static !transient <fields>;
   private void writeObject(java.io.ObjectOutputStream);
   private void readObject(java.io.ObjectInputStream);
   java.lang.Object writeReplace();
   java.lang.Object readResolve();
}

-keepclassmembers class * {
   public <init>(org.json.JSONObject);
}

# 对R文件下的所有类及其方法，都不能被混淆
-keepclassmembers class **.R$* {
    public static <fields>;
}

# 对于带有回调函数onXXEvent的，不能混淆
-keepclassmembers class * {
    void *(**on*Event);
}

-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

-dontwarn android.support.**
-keep class android.support.v4.** { *; }
-keep class android.support.multidex.** { *; }
-keep interface android.support.v4.app.** { *; }
-keep public class * extends android.support.v4.**
-keep public class * extends android.app.Fragment
-keep public class * extends com.gkoudai.finance.mvp.BaseModel{
 *;
}

-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
#okio包中不发出警告
-dontwarn okio.**
-dontwarn com.squareup.okhttp.**


-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}


-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

-keep public class org.sojex.finance.trade.widget.ShareUmengView {
     public ShareUmengView(android.app.Activity,java.lang.String);
     public void showSharePic(java.lang.String);
}

-keep public class org.sojex.finance.trade.presenters.TradeCircleItemPresenter{
    public <init>(android.content.Context);
    public void groupShareMessage(java.lang.String);
}
-dontwarn com.umeng.**
-keep class com.umeng.**{ *; }

-keep class com.google.gson.**{ *; }

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
#  避免混淆泛型、抛出异常时保留代码行号
-keepattributes Signature,SourceFile,LineNumberTable

# For using GSON @Expose annotation
# 保护代码中的Annotation不被混淆
# 这在JSON实体映射时非常重要，比如fastJson
-keepattributes *Annotation*

# Gson specific classes
-keep class sun.misc.Unsafe { *; }
#-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
#-keep class org.sojex.finace.bean.** { *; }

##---------------End: proguard configuration for Gson  ----------


-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}
##WebView JS混淆过滤
-keepnames class org.sojex.finance.active.markets.WeiPanActivity$*{
    public <methods>;}

-keepnames class org.sojex.finance.active.news.NewsDetailActivity$*{
    public <methods>;}

-keepnames class org.sojex.finance.active.explore.yy.YYActivity$*{
    public <methods>;}

-keepnames class org.sojex.finance.view.WebViewActivity$*{
    public <methods>;}

-dontwarn com.tencent.**
-keep class com.tencent.** { *; }

-dontwarn org.jsoup.**
-keep class org.jsoup.** { *; }

-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }

-dontwarn org.achartengine.**
-keep class org.achartengine.** { *; }

-dontwarn com.google.zxing.**
-keep class com.google.zxing.** { *; }

-keep class com.aps.** { *; }

-dontwarn com.alipay.android.app.**
-keep class com.alipay.android.app.** { *; }

-keep class com.duowan.mobile.** { *; }
-keep class com.sina.sso.** { *; }
-keep class net.bither.util.** { *; }
-keep class org.sojex.finance.bean.** { *; }
-keep class org.apache.http.entity.mime.** { *; }
-keep class u.upd.** { *; }

-keep public class org.sojex.finance.common.GloableData {
    public <methods>;
}

-keep public class org.sojex.finance.common.DESede {
    public <methods>;
}

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
#-keep class com.tencent.mm.sdk.openapi.WXMediaMessage {*;}
#-keep class com.tencent.mm.sdk.openapi.** implements com.tencent.mm.sdk.openapi.WXMediaMessage$IMediaObject {*;}
# keep butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }

-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}

# keep eventbus
-keepclassmembers class ** {
    public void onEvent*(**);
}

-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}

# keep models todo check event class
-keep class org.sojex.finance.trade.modules.**{ *; }
-keep class org.sojex.finance.bean.**{ *; }
-keep class com.zhenghaiqiang.shanbeireader.bean.**{ *; }
-keep class sp.phone.bean.**{ *; }
-keep class com.alibaba.android.arouter.**{ *; }



-keep class org.sojex.finance.greendao.circletrade.**{ *; }
-keep class org.sojex.finance.greendao.loggather.**{ *; }

-keep class com.bugtags.library.**{ *; }
-dontwarn com.bugtags.library.**
-keep class org.jboss.netty.**{ *; }
-dontwarn org.jboss.netty.**

-keep class android.provider.Settings{ *; }
-keepclasseswithmembernames class com.bugtags.library.** {
    public <fields>;
    public <methods>;
}

-keep class u.upd.o{ *; }
-keep class com.aps.cc{ *; }
-keep class com.a{ *; }
-keep class com.sojext.**{ *; }
-keep class com.android.volley.b{ *; }
-keep class org.sojex.finance.BuildConfig{ *; }
-keep class org.sojex.finance.floatwindow.MyWindowManager{ *; }

#keep mipush receiver
-keep class org.sojex.finance.push.xiaomi.MiPushReceiver {*;}

# keep huawei push
-keep class com.huawei.android.pushagent.**{*;}
-keep class com.huawei.android.pushselfshow.**{*;}
-keep class com.huawei.android.microkernel.**{*;}
-keep class com.baidu.mapapi.**{*;}


# keep umeng socialize
-keep public interface com.tencent.**
-keep public interface com.umeng.socialize.**
-keep public interface com.umeng.socialize.sensor.**
-keep public interface com.umeng.scrshot.**
-keep public class com.umeng.socialize.* {*;}
-keep public class javax.**
-keep class com.umeng.scrshot.**
-keep class com.umeng.socialize.sensor.**
-keep class com.umeng.socialize.handler.**
-keep class com.umeng.socialize.handler.*
-keep class com.tencent.** {*;}
-keep public class com.umeng.soexample.R$*{
    public static final int *;
}
-keep public class com.umeng.soexample.R$*{
    public static final int *;
}
-keep class com.sina.** {*;}

-keepclassmembers class * extends android.webkit.WebChromeClient {
    public void openFileChooser(...);
}

# AndFix
-keep class com.alipay.euler.andfix.** {*;}

# GreenDao
-keep class de.greenrobot.dao.** { *; }

# Glide
-keep class org.sojex.finance.glide.GlideModuleConfig { *; }

# keep 百度统计
-keep class com.baidu.kirin.** { *; }
-keep class com.baidu.mobstat.** { *; }
-keep class com.baidu.bottom.** { *; }
#小米
-dontwarn com.xiaomi.push.**

# keep 华为推送
-keep class com.huawei.hms.**{*;}
# hmscore-support:remote transport
#-keep class * extends com.huawei.hms.core.aidl.IMessageEntity { *; }
# hmscore-support: remote transport
#-keepclasseswithmembers class * implements com.huawei.hms.support.api.transport.DatagramTransport {
#    <init>(...);
#}
# manifest: provider for update
#-keep public class com.huawei.hms.update.provider.UpdateProvider { public *; protected *;}


# tencent x5 过滤
#-renamesourcefileattribute TbsSdkJava
#-keep class com.tencent.smtt.** { *; }
#-keep class com.tencent.tbs.** { *; }
#-keep class MTT.** { *; }
#------------------  下方是共性的排除项目         ----------------
# 方法名中含有“JNI”字符的，认定是Java Native Interface方法，自动排除
# 方法名中含有“JRI”字符的，认定是Java Reflection Interface方法，自动排除

-keepclasseswithmembers class * {
    ... *JNI*(...);
}

-keepclasseswithmembernames class * {
	... *JRI*(...);
}

-keep class **JNI* {*;}

# keep 异度支付
-keepattributes Exceptions,InnerClasses
-keep class com.citicbank.**{*;}
-keep class org.bouncycastle.**{*;}
-keep class org.dom4j.**{*;}
-keep class org.jaxen.**{*;}
-keep class org.w3c.dom.**{*;}

#图表
-keep class com.kingbi.corechart.utils.CalendarEffect{*;}

#环信
-keep class com.hyphenate.**{*;}
-dontwarn  com.hyphenate.**

#视频
-keep class tv.danmaku.ijk.media.player.** {*;}

#加密
-keepclassmembers class org.sojex.finance.manager.GsonRequest {
    public java.lang.String key;
}
#浦发软键盘
-keep class cn.passguard.** { *; }
-keep class cn.pf.passguard.** { *; }

# 阿里云风控sdk
-keep class com.taobao.securityjni.**{*;}
-keep class com.taobao.wireless.security.**{*;}
-keep class com.ut.secbody.**{*;}
-keep class com.taobao.dp.**{*;}
-keep class com.alibaba.wireless.security.**{*;}
-keep class com.alibaba.verificationsdk.**{*;}
-keep interface com.alibaba.verificationsdk.ui.IActivityCallback


# ---------------------x5内核过滤--------------------------------
#@proguard_debug_start
# ------------------ Keep LineNumbers and properties ---------------- #
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod
#-renamesourcefileattribute TbsSdkJava
#-keepattributes SourceFile,LineNumberTable
#@proguard_debug_end

# --------------------------------------------------------------------------
# Addidional for x5.sdk classes for apps

-keep class com.tencent.smtt.export.external.**{
    *;
}

-keep class com.tencent.tbs.video.interfaces.IUserStateChangedListener {
	*;
}

-keep class com.tencent.smtt.sdk.CacheManager {
	public *;
}

-keep class com.tencent.smtt.sdk.CookieManager {
	public *;
}

-keep class com.tencent.smtt.sdk.WebHistoryItem {
	public *;
}

-keep class com.tencent.smtt.sdk.WebViewDatabase {
	public *;
}

-keep class com.tencent.smtt.sdk.WebBackForwardList {
	public *;
}

-keep public class com.tencent.smtt.sdk.WebView {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebView$HitTestResult {
	public static final <fields>;
	public java.lang.String getExtra();
	public int getType();
}

-keep public class com.tencent.smtt.sdk.WebView$WebViewTransport {
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebView$PictureListener {
	public <fields>;
	public <methods>;
}


-keepattributes InnerClasses

-keep public enum com.tencent.smtt.sdk.WebSettings$** {
    *;
}

-keep public enum com.tencent.smtt.sdk.QbSdk$** {
    *;
}

-keep public class com.tencent.smtt.sdk.WebSettings {
    public *;
}

# 避免混淆泛型
# 这在JSON实体映射时非常重要，比如fastJson
-keepattributes Signature
-keep public class com.tencent.smtt.sdk.ValueCallback {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebViewClient {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.DownloadListener {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebChromeClient {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebChromeClient$FileChooserParams {
	public <fields>;
	public <methods>;
}

-keep class com.tencent.smtt.sdk.SystemWebChromeClient{
	public *;
}
# 1. extension interfaces should be apparent
-keep public class com.tencent.smtt.export.external.extension.interfaces.* {
	public protected *;
}

# 2. interfaces should be apparent
-keep public class com.tencent.smtt.export.external.interfaces.* {
	public protected *;
}

-keep public class com.tencent.smtt.sdk.WebViewCallbackClient {
	public protected *;
}

-keep public class com.tencent.smtt.sdk.WebStorage$QuotaUpdater {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebIconDatabase {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.WebStorage {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.DownloadListener {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.QbSdk {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.QbSdk$PreInitCallback {
	public <fields>;
	public <methods>;
}
-keep public class com.tencent.smtt.sdk.CookieSyncManager {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.Tbs* {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.utils.LogFileUtils {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.utils.TbsLog {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.utils.TbsLogClient {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.CookieSyncManager {
	public <fields>;
	public <methods>;
}

# Added for game demos
-keep public class com.tencent.smtt.sdk.TBSGamePlayer {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.TBSGamePlayerClient* {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.TBSGamePlayerClientExtension {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.sdk.TBSGamePlayerService* {
	public <fields>;
	public <methods>;
}

-keep public class com.tencent.smtt.utils.Apn {
	public <fields>;
	public <methods>;
}
-keep class com.tencent.smtt.** {
	*;
}
# end


-keep public class com.tencent.smtt.export.external.extension.proxy.ProxyWebViewClientExtension {
	public <fields>;
	public <methods>;
}

-keep class MTT.ThirdAppInfoNew {
	*;
}

-keep class com.tencent.mtt.MttTraceEvent {
	*;
}

# Game related
-keep public class com.tencent.smtt.gamesdk.* {
	public protected *;
}

-keep public class com.tencent.smtt.sdk.TBSGameBooter {
        public <fields>;
        public <methods>;
}

-keep public class com.tencent.smtt.sdk.TBSGameBaseActivity {
	public protected *;
}

-keep public class com.tencent.smtt.sdk.TBSGameBaseActivityProxy {
	public protected *;
}

-keep public class com.tencent.smtt.gamesdk.internal.TBSGameServiceClient {
	public *;
}
#---------------------------------------------------------------------------
# >>>>>>> 1124829... x5内核升级
-keep class com.growingio.android.sdk.** {
    *;
}
-dontwarn com.growingio.android.sdk.**
-keepnames class * extends android.view.View
-keep class * extends android.app.Fragment {
    public void setUserVisibleHint(boolean);
    public void onHiddenChanged(boolean);
    public void onResume();
    public void onPause();
}
-keep class android.support.v4.app.Fragment {
    public void setUserVisibleHint(boolean);
    public void onHiddenChanged(boolean);
    public void onResume();
    public void onPause();
}
-keep class * extends android.support.v4.app.Fragment {
    public void setUserVisibleHint(boolean);
    public void onHiddenChanged(boolean);
    public void onResume();
    public void onPause();
}
-keep class com.growingio.android.sdk.collection.GrowingIOInstrumentation {
    public *;
    static <fields>;
}

#------------------------以下是被反射类的忽略混淆--------------------------------------------------------
-keep class org.sojex.finance.router.**



-keep class com.superrtc.** {
	*;
}
-keep class com.hyphenate.** {
	*;
}

-keep public class com.alibaba.android.arouter.routes.**{*;}

-dontwarn rx.*
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQuene*Field*{
long producerIndex;
long consumerIndex;
}

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
rx.internal.util.atomic.LinkedQueueNode producerNode;
rx.internal.util.atomic.LinkedQueueNode consumerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

-dontwarn okhttp3.logging.**
-keep class okhttp3.internal.**{*;}
-dontwarn okio.**

-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

