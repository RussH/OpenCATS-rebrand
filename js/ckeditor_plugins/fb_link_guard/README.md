# fb_link_guard deployment notes

`fb_link_guard` is a CKEditor 4 plugin for the OpenCATS job description editor. It flags malformed or disallowed links in job descriptions, highlights them inside the editor, and warns recruiters before publishing.

## Deployment summary

This plugin should work as-is after deployment when the following are true:

- The deployment copies the full `js/ckeditor_plugins/fb_link_guard/` directory.
- `js/ckeditor-manager.js` is refreshed in browser, proxy, and CDN caches.
- The deployed CKEditor build includes the CKEditor `notification` plugin.
- The Add/Edit Job Order pages continue loading assets from the app root, as they already do for `js/ckeditor-manager.js`.

No database migration, PHP configuration, or extra page-level stylesheet include is required for this PR.

## How the plugin is loaded

The Add and Edit Job Order pages already include CKEditor and `js/ckeditor-manager.js`, then call `placeCkEditorIn('description')` for the job description field.

`placeCkEditorIn(nodeId)` registers and enables `fb_link_guard` only when `nodeId` is `description`, so other CKEditor instances are not affected.

The plugin is loaded from:

```text
js/ckeditor_plugins/fb_link_guard/plugin.js
```

and its editor-only CSS is loaded by the plugin from:

```text
js/ckeditor_plugins/fb_link_guard/styles.css
```

## CSS behavior

No additional PHP template `<link>` tag is needed for invalid-link highlighting inside CKEditor. The plugin calls `editor.addContentsCss(...)`, which loads `styles.css` into CKEditor’s editable document.

The CSS marks invalid anchors with `.fb-invalid-link` using a highlighted background, red underline/border treatment, and dashed outline.

## CKEditor notification dependency

The plugin declares a dependency on CKEditor’s `notification` plugin and uses it to show warnings such as:

```text
Invalid links found in this job description. Please fix highlighted links before publishing.
```

Before deploying, confirm this file exists in the deployed CKEditor package:

```text
vendor/ckeditor/ckeditor/plugins/notification/plugin.js
```

If it is missing, CKEditor may log a plugin load error. In that case, either deploy CKEditor’s official `notification` plugin assets or adjust `fb_link_guard` to degrade gracefully without notifications. The current implementation intentionally keeps the notification dependency because recruiter-facing warnings were a requirement.

## Static asset deployment checklist

Ensure the deployment includes these files:

```text
js/ckeditor_plugins/fb_link_guard/plugin.js
js/ckeditor_plugins/fb_link_guard/styles.css
js/ckeditor_plugins/fb_link_guard/README.md
```

Also purge or bypass caches for:

```text
js/ckeditor-manager.js
js/ckeditor_plugins/fb_link_guard/plugin.js
js/ckeditor_plugins/fb_link_guard/styles.css
```

## Validation scope

This plugin is a client-side recruiter warning. It does not rewrite content, block the PHP form submit, or add server-side validation.

Server-side validation should remain separate and should be treated as the final safety net if publishing must be blocked for malformed links.
