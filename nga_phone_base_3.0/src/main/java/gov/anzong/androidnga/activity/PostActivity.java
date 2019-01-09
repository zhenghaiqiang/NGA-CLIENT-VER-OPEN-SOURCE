package gov.anzong.androidnga.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.BackgroundColorSpan;
import android.text.style.StyleSpan;

import com.alibaba.android.arouter.facade.annotation.Route;

import gov.anzong.androidnga.R;
import gov.anzong.androidnga.arouter.ARouterConstants;
import sp.phone.forumoperation.ParamKey;
import sp.phone.forumoperation.PostParam;
import sp.phone.fragment.TopicPostFragment;

@Route(path = ARouterConstants.ACTIVITY_POST)
public class PostActivity extends BaseActivity {

    private TopicPostFragment mPostFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setActionBarEnabled(false);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_post);
        setupToolbar();
        PostParam act = getPostParam();
        setTitle(getTitleResId(act.getPostAction()));
        Bundle bundle = new Bundle();
        bundle.putString(ParamKey.KEY_ACTION, act.getPostAction());
        bundle.putParcelable("param", act);
        if (savedInstanceState != null) {
            bundle.putBundle("savedInstanceState", savedInstanceState);
        }
        mPostFragment = new TopicPostFragment();
        mPostFragment.setArguments(bundle);
        mPostFragment.setHasOptionsMenu(true);
        getSupportFragmentManager().beginTransaction().replace(R.id.content, mPostFragment).commit();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mPostFragment.onSaveInstanceState(outState);
    }

    private int getTitleResId(String action) {
        switch (action) {
            case "reply":
                return R.string.reply_thread;
            case "modify":
                return R.string.modify_thread;
            default:
                return R.string.new_thread;
        }
    }

    private PostParam getPostParam() {
        Intent intent = getIntent();
        String tid = intent.getStringExtra(ParamKey.KEY_TID);
        int fid = intent.getIntExtra(ParamKey.KEY_FID, -7);
        String title = intent.getStringExtra("title");
        String pid = intent.getStringExtra(ParamKey.KEY_PID);
        String action = intent.getStringExtra(ParamKey.KEY_ACTION);
        String prefix = intent.getStringExtra("prefix");
        if (prefix != null && prefix.startsWith("[quote][pid=") && prefix.endsWith("[/quote]\n")) {
            SpannableString spanString = new SpannableString(prefix);
            spanString.setSpan(new BackgroundColorSpan(-1513240), 0, prefix.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            spanString.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), prefix.indexOf("[b]Post by"), prefix.indexOf("):[/b]") + 5, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            prefix = spanString.toString();
        }
        PostParam act = new PostParam(tid, "", "");
        act.setPostAction(action);
        act.setPostFid(fid);
        act.setPostPid(pid);
        act.setPostContent(prefix);
        act.setPostSubject(title);
        return act;
    }

    @Override
    public void onBackPressed() {
        if (!mPostFragment.onBackPressed()) {
            super.onBackPressed();
        }
    }
}