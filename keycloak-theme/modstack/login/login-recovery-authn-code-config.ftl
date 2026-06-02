<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('recoveryCodeInput') showMarketingPanel=false; section>

  <#if section = "header">
    Recovery codes
  <#elseif section = "subtitle">
    Save these codes somewhere safe. If you lose your authenticator, you can use one of these to sign in.
  <#elseif section = "form">

    <div class="ms-recovery-codes">
      <ul class="ms-recovery-codes__list">
        <#list recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesList as code>
          <li>${code}</li>
        </#list>
      </ul>
      <button type="button" class="ms-recovery-codes__copy" id="copyRecoveryCodes">
        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        Copy codes
      </button>
    </div>

    <p style="font-size:13px;color:#888888;text-align:center;margin-bottom:24px;">Each code can only be used once. You will not see these again.</p>

    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="generatedRecoveryAuthnCodes" value="${recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesAsString}">
      <input type="hidden" name="generatedAt" value="${recoveryAuthnCodesConfigBean.generatedAt?c}">
      <input type="hidden" id="userLabel" name="userLabel" value="${msg('recovery-codes-label-default')}">
      <div class="ms-form-actions">
        <button type="submit" class="ms-btn ms-btn--primary">I've saved my codes</button>
      </div>
    </form>

    <script>
      document.getElementById('copyRecoveryCodes').addEventListener('click', function() {
        var codes = [];
        document.querySelectorAll('.ms-recovery-codes__list li').forEach(function(li) {
          codes.push(li.textContent.trim());
        });
        navigator.clipboard.writeText(codes.join('\n')).then(function() {
          var btn = document.getElementById('copyRecoveryCodes');
          var original = btn.innerHTML;
          btn.textContent = 'Copied!';
          setTimeout(function() { btn.innerHTML = original; }, 2000);
        });
      });
    </script>

  </#if>

</@layout.registrationLayout>
