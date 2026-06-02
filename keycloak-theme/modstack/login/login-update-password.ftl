<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-new','password-confirm') showMarketingPanel=false; section>

  <#if section = "header">
    Update password
  <#elseif section = "subtitle">
    Please choose a new password for your account
  <#elseif section = "form">

    <form action="${url.loginAction}" method="post">

      <#-- New password -->
      <div class="ms-form-group">
        <label for="password-new">${msg("passwordNew")} <span class="ms-required">*</span></label>
        <input id="password-new" name="password-new" type="password" class="ms-input <#if messagesPerField.existsError('password','password-new')>ms-input--error</#if>" autocomplete="new-password" autofocus>
        <#if messagesPerField.existsError('password-new')>
          <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.getFirstError('password-new'))?no_esc}</div>
        </#if>
      </div>

      <#-- Confirm password -->
      <div class="ms-form-group">
        <label for="password-confirm">${msg("passwordConfirm")} <span class="ms-required">*</span></label>
        <input id="password-confirm" name="password-confirm" type="password" class="ms-input <#if messagesPerField.existsError('password-confirm')>ms-input--error</#if>" autocomplete="new-password">
        <#if messagesPerField.existsError('password-confirm')>
          <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}</div>
        </#if>
      </div>

      <#-- Submit -->
      <div class="ms-form-actions">
        <#if isAppInitiatedAction??>
          <div class="ms-btn-row">
            <button type="submit" class="ms-btn ms-btn--primary">${msg("doSubmit")}</button>
            <button type="submit" name="cancel-aia" value="true" class="ms-btn ms-btn--ghost">${msg("doCancel")}</button>
          </div>
        <#else>
          <button type="submit" class="ms-btn ms-btn--primary">${msg("doSubmit")}</button>
        </#if>
      </div>

    </form>

  </#if>

</@layout.registrationLayout>
