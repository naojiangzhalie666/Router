package io.flutter.facade

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import com.colin.flutterlogin.R
import com.ifenghui.commonlibrary.base.ui.activity.BaseLazyActivity

class FlutterActivity : BaseLazyActivity() {
    override fun onCreateDelay(bundle: Bundle?) {
        //route1是在flutter代码中定义，用来确定显示哪个flutter view
        val flag = intent.getStringExtra("flag")
        changeTitle(flag)
        addFlutterView(flag)
    }

    override fun onBindLayout(): Int {
        return R.layout.activity_login
    }

    @SuppressLint("ResourceAsColor")
    private fun addFlutterView(flag:String?){
        var flutterView = Flutter.createView(this, lifecycle, flag)
        var frameLayout = ConstraintLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        addContentView(flutterView, frameLayout)
//        flutterView.setBackgroundColor(R.color.white)
    }

    private fun changeTitle(flag:String?){
        if ("login"==flag)
            resetToolBarTitle("登录")
    }
}