<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false showMarketingPanel=false; section>

  <#if section = "header">
  <#elseif section = "subtitle">
  <#elseif section = "form">

    <div class="ms-logout-header">
      <div class="ms-logout-header__text">
        <h2 class="ms-logout-header__title">Sign out</h2>
        <p class="ms-logout-header__desc">Are you sure you want to sign out?</p>
      </div>
      <div class="ms-logout-header__icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" y1="12" x2="9" y2="12"/>
        </svg>
      </div>
    </div>

    <p style="font-size:14px;color:#888888;margin-bottom:28px;">You will be signed out of your account and will need to sign in again to continue.</p>

    <form action="${url.logoutConfirmAction}" method="post">
      <input type="hidden" name="session_code" value="${logoutConfirm.code}">
      <div class="ms-form-actions" style="margin-top:0;">
        <button type="submit" class="ms-btn ms-btn--primary">Yes, sign out</button>
        <#if (logoutConfirm.skipLink)?? && !logoutConfirm.skipLink && (logoutConfirm.backUrl)??>
          <a href="${logoutConfirm.backUrl}" class="ms-btn ms-btn--ghost" style="text-align:center;margin-top:10px;">Cancel</a>
        </#if>
      </div>
    </form>

  </#if>

</@layout.registrationLayout>
