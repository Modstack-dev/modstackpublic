<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp') showMarketingPanel=false; section>

  <#if section = "header">
    Two-factor authentication
  <#elseif section = "subtitle">
    Enter the code from your authenticator app
  <#elseif section = "form">

    <form action="${url.loginAction}" method="post">

      <#-- Credential selector (OTP vs recovery codes) -->
      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="ms-form-group">
          <label for="selectedCredentialId">${msg("loginOtpDevice")}</label>
          <select id="selectedCredentialId" name="selectedCredentialId" class="ms-input">
            <#list otpLogin.userOtpCredentials as otpCredential>
              <option value="${otpCredential.id}" <#if otpCredential.id == otpLogin.selectedCredentialId>selected</#if>>${otpCredential.userLabel}</option>
            </#list>
          </select>
        </div>
      </#if>

      <div class="ms-form-group">
        <label for="otp">${msg("loginOtpOneTime")}</label>
        <input id="otp" name="otp" type="text" class="ms-input <#if messagesPerField.existsError('totp')>ms-input--error</#if>" autocomplete="one-time-code" autofocus inputmode="numeric" pattern="[0-9]*">
      </div>

      <div class="ms-form-actions">
        <button type="submit" class="ms-btn ms-btn--primary">${msg("doLogIn")}</button>
      </div>

    </form>

    <#-- Link to try another way (e.g. recovery codes) -->
    <#if (auth.authenticationSelections)?? && auth.authenticationSelections?size gt 1>
      <div class="ms-separator">or</div>
      <div class="ms-alt-auth">
        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
          <input type="hidden" name="tryAnotherWay" value="on">
          <a href="#" class="ms-alt-auth__link" onclick="document.getElementById('kc-select-try-another-way-form').submit();return false;">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            Try another way to sign in
          </a>
        </form>
      </div>
    </#if>

  </#if>

</@layout.registrationLayout>
