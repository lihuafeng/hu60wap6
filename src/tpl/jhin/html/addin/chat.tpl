{extends file='tpl:comm.default'}

{block name='title'}
聊天室-{$roomname}
{/block}

{block name='body'}
{include file="tpl:comm.at"}
<div class="breadcrumb">
  <a href="index.index.{$bid}" title="回首页">回首页</a>
  {$roomname}
  <a href="addin.chat.{$bid}">切换聊天室</a>
  <a href="addin.chat.{$PAGE->ext[0]|code}.{$bid}?rand={time()}">刷新</a>
</div>
<div class="text-failure">{$err_msg}</div>
<div class="widget-form">
  <form method="post" action="addin.chat.{$roomname}.{$bid}" class="chat-form">
    <div>
      <textarea id="content" name="content" class="chat-form-content">{$smarty.post.content|code:false:true}</textarea>
      <p>
        {if $USER->islogin}
        <input type="hidden" name="token" value="{$token->token()}">
        <input type="submit" id="quick_chat_button" name="go" id="submit" class="chat-form-submit" value="快速发言"/>
        <input type="button" id="add_files" value="添加附件" class="chat-form-submit" onclick="addFiles()"/>
        {include file="tpl:comm.addfiles"}
        {else}
        必须<a href="user.login.{$BID}?u={$PAGE->geturl()|urlencode}">登录</a>才能发言。
        {/if}
      </p>
    </div>
  </form>
</div>
<ul class="chat-list">
  {foreach $list as $k}
  {if $k.hidden}
  <li>
    {$tmp = $uinfo->uid($k.hidden)}
    {*if $k.hidden == $k.uid}
    {$k.lid}. 该楼层已被层主 <a href="#" onclick="atAdd('{$uinfo->name|code}',this);return false">@</a><a href="user.info.{$k.hidden}.{$BID}">{$uinfo->name|code}</a> 自行删除。
    {else*}
    {$k.lid}. 该楼层已被管理员 <a href="#" onclick="atAdd('{$uinfo->name|code}',this);return false">@</a><a href="user.info.{$k.hidden}.{$BID}">{$uinfo->name|code}</a> 删除，层主：<a href="#" onclick="atAdd('{$k.uname|code}',this);return false">@</a><a href="user.info.{$k.uid}.{$BID}">{$k.uname|code}</a>。
    {*/if*}
  </li>
  {else}
  {$tmp = $uinfo->uid($k.uid)}
  {$tmp = $ubbs->setOpt('style.disable', $uinfo->hasPermission(UserInfo::PERMISSION_UBB_DISABLE_STYLE))}
  <li>
    <div class="chat-number">{$k.lid}</div>
    <div class="chat-content">
      {$ubbs->display($k.content,true)}</div>
    <div class="chat-meta">
      (<div class="chat-meta-name">
        <a href="user.info.{$k.uid}.{$BID}">{$k.uname|code}</a>
      </div><a href="#" onclick="atAdd('{$k.uname|code}',this);return false">@Ta</a> {date("m-d H:i:s",{$k.time})}{if $chat->canDel($k.uid,true)}/
      <a href="?del={$k.id}&amp;p={$p}&amp;t={$smarty.server.REQUEST_TIME}" onclick="return confirm('您确定要删除该楼层？')">删</a>{/if})
    </div>
  </li>
  {/if}
  {/foreach}
</ul>
<div class="widget-page">
  {str::pageFormat($p,$maxP,"?p=##")}
</div>

{/block}