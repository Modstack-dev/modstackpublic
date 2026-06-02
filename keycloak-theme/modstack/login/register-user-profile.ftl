<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayInfo=true showMarketingPanel=true; section>

  <#if section = "header">
    Create your account
  <#elseif section = "subtitle">
    Get started with ${realm.displayName!'your account'}
  <#elseif section = "form">

    <form id="kc-register-form" action="${url.registrationAction}" method="post">

      <@userProfileCommons.userProfileFormFields; callback, attribute>
        <#if callback = "afterField">
          <#-- Render password fields after username or email -->
          <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
            <div class="ms-form-group">
              <label for="password">${msg("password")} <span class="ms-required">*</span></label>
              <input type="password" id="password" name="password" class="ms-input <#if messagesPerField.existsError('password','password-confirm')>ms-input--error</#if>" autocomplete="new-password">
              <#if messagesPerField.existsError('password')>
                <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.get('password'))?no_esc}</div>
              </#if>
            </div>

            <div class="ms-form-group">
              <label for="password-confirm">${msg("passwordConfirm")} <span class="ms-required">*</span></label>
              <input type="password" id="password-confirm" name="password-confirm" class="ms-input <#if messagesPerField.existsError('password-confirm')>ms-input--error</#if>" autocomplete="new-password">
              <#if messagesPerField.existsError('password-confirm')>
                <div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</div>
              </#if>
            </div>
          </#if>
        </#if>
      </@userProfileCommons.userProfileFormFields>

      <div class="ms-form-actions">
        <button type="submit" class="ms-btn ms-btn--primary">${msg("doRegister")}</button>
      </div>

    </form>

  <#elseif section = "info">
    Already have an account? <a href="${url.loginUrl}">${msg("doLogIn")}</a>
  </#if>

</@layout.registrationLayout>
