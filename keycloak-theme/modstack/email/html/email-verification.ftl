<#import "template.ftl" as layout>
<@layout.emailLayout>

  <h1 style="margin:0 0 8px;font-size:22px;font-weight:700;color:#1a1a1a;">Verify your email</h1>
  <p style="margin:0 0 24px;font-size:15px;color:#555555;line-height:1.5;">Please confirm your email address to finish setting up your account.</p>

  <!-- Button -->
  <table role="presentation" cellpadding="0" cellspacing="0" style="margin:0 0 24px;">
    <tr>
      <td align="center" style="background-color:#1a1a1a;border-radius:6px;">
        <a href="${link}" target="_blank" style="display:inline-block;padding:12px 28px;font-size:14px;font-weight:600;color:#ffffff;text-decoration:none;">Verify email address</a>
      </td>
    </tr>
  </table>

  <p style="margin:0 0 8px;font-size:12px;color:#888888;line-height:1.5;">If the button doesn't work, copy and paste this link into your browser:</p>
  <p style="margin:0 0 24px;font-size:11px;word-break:break-all;color:#888888;line-height:1.5;background:#f5f5f5;border-radius:6px;padding:10px 12px;border:1px solid #e5e5e5;"><a href="${link}" style="color:#1a1a1a;text-decoration:none;">${link}</a></p>

  <hr style="border:none;border-top:1px solid #eeeeee;margin:24px 0;">

  <p style="margin:0;font-size:13px;color:#888888;line-height:1.6;">If you didn't create an account, you can safely ignore this email.</p>

</@layout.emailLayout>
