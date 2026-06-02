<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('recoveryCodeInput') showMarketingPanel=false; section>

  <#if section = "header">
    Enter recovery code
  <#elseif section = "subtitle">
    Use one of the recovery codes you saved during setup
  <#elseif section = "form">

    <form action="${url.loginAction}" method="post">

      <div class="ms-form-group">
        <label for="recoveryCodeInput">Recovery code</label>
        <input id="recoveryCodeInput" name="recoveryCodeInput" type="text" class="ms-input <#if messagesPerField.existsError('recoveryCodeInput')>ms-input--error</#if>" autocomplete="off" autofocus placeholder="xxxx-xxxx-xxxx">
        <#if messagesPerField.existsError('recoveryCodeInput')>
          <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.getFirstError('recoveryCodeInput'))?no_esc}</div>
        </#if>
      </div>

      <div class="ms-form-actions">
        <button type="submit" class="ms-btn ms-btn--primary">${msg("doLogIn")}</button>
      </div>

    </form>

    <#-- Try another way -->
    <#if (auth.authenticationSelections)?? && auth.authenticationSelections?size gt 1>
      <div class="ms-separator">or</div>
      <div class="ms-alt-auth">
        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
          <input type="hidden" name="tryAnotherWay" value="on">
          <a href="#" class="ms-alt-auth__link" onclick="document.getElementById('kc-select-try-another-way-form').submit();return false;">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>
            Use authenticator app instead
          </a>
        </form>
      </div>
    </#if>

  </#if>

</@layout.registrationLayout>
