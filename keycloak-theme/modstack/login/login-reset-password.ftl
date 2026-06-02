<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username') displayInfo=true showMarketingPanel=false; section>

  <#if section = "header">
    Reset your password
  <#elseif section = "subtitle">
    Enter your email address and we'll send you a link to reset your password.
  <#elseif section = "form">

    <form action="${url.loginAction}" method="post">

      <div class="ms-form-group">
        <label for="username">
          <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
        </label>
        <input id="username" name="username" type="text" class="ms-input <#if messagesPerField.existsError('username')>ms-input--error</#if>" autocomplete="username" autofocus placeholder="you@company.com">
        <#if messagesPerField.existsError('username')>
          <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}</div>
        </#if>
      </div>

      <div class="ms-form-actions">
        <button type="submit" class="ms-btn ms-btn--primary">Send reset link</button>
      </div>

    </form>

  <#elseif section = "info">
    <a href="${url.loginUrl}" class="ms-back-link">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
      Back to sign in
    </a>
  </#if>

</@layout.registrationLayout>
