(function () {
    'use strict';

    var WARNING_MESSAGE = 'Invalid links found in this job description. Please fix highlighted links before publishing.';
    var INVALID_CLASS = 'fb-invalid-link';

    function trim(value) {
        return String(value || '').replace(/^\s+|\s+$/g, '');
    }

    function isValidMailtoEmail(value) {
        var email = value.replace(/^mailto:/i, '');
        if (email.indexOf('?') !== -1) {
            email = email.split('?')[0];
        }
        return /^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$/.test(email);
    }

    function getLinkIssue(href) {
        var value = trim(href);
        var lower = value.toLowerCase();

        if (!value) {
            return 'Link URL is empty.';
        }
        if ((value.charAt(0) === '"' && value.charAt(value.length - 1) === '"') ||
            (value.charAt(0) === '\'' && value.charAt(value.length - 1) === '\'')) {
            return 'Link URL is wrapped in literal quotes. Remove the quotes from the URL.';
        }
        if (value.indexOf('\"') !== -1 || value.indexOf("'") !== -1) {
            return 'Link URL contains literal quotes. Remove the quotes from the URL.';
        }
        if (lower.indexOf('&quot;') !== -1) {
            return 'Link URL contains &quot;. Remove encoded quotes from the URL.';
        }
        if (/^https?:\/[^\/]/i.test(value)) {
            return 'Link URL uses only one slash after http: or https:. Use http:// or https://.';
        }
        if (/^\/job\/.*\/(?:https?|mailto):/i.test(value) || /\/job\/[^?#]*\/(?:\"|'|%22)?(?:https?|mailto):/i.test(value)) {
            return 'Link URL appears to contain a malformed job-relative absolute link.';
        }
        if (/^(?:javascript|data|file):/i.test(value)) {
            return 'Link URL uses a blocked scheme. Use http://, https://, mailto:, or a site-relative path.';
        }
        if (/^mailto:/i.test(value) && !isValidMailtoEmail(value)) {
            return 'Mailto link must contain a valid email address.';
        }
        if (!/^(?:https?:\/\/|mailto:|\/)/i.test(value)) {
            return 'Link URL must start with http://, https://, mailto:, or /.';
        }

        return '';
    }

    function debounce(fn, wait) {
        var timer = null;
        return function () {
            var args = arguments;
            var context = this;
            window.clearTimeout(timer);
            timer = window.setTimeout(function () {
                fn.apply(context, args);
            }, wait);
        };
    }

    function scanEditor(editor) {
        var editable = editor.editable && editor.editable();
        var invalidCount = 0;

        if (!editable || !editable.find) {
            return 0;
        }

        var links = editable.find('a[href]');
        for (var i = 0; i < links.count(); i++) {
            var link = links.getItem(i);
            var issue = getLinkIssue(link.getAttribute('href'));

            if (issue) {
                link.addClass(INVALID_CLASS);
                link.setAttribute('title', issue);
                invalidCount++;
            } else {
                link.removeClass(INVALID_CLASS);
                if (link.getAttribute('title') && link.getAttribute('title').match(/^Link URL|^Mailto link|^Invalid|^Link URL appears|^Link URL uses/)) {
                    link.removeAttribute('title');
                }
            }
        }

        if (invalidCount && editor.showNotification) {
            editor.showNotification(WARNING_MESSAGE, 'warning');
        }

        return invalidCount;
    }

    function attachDialogValidation(editor) {
        editor.on('dialogShow', function (event) {
            var dialog = event.data;
            if (!dialog || dialog.getName() !== 'link') {
                return;
            }

            var urlField = dialog.getContentElement('info', 'url');
            if (!urlField || urlField.fbLinkGuardWrapped) {
                return;
            }

            var originalValidate = urlField.validate;
            urlField.validate = function () {
                var value = this.getValue();
                var protocolField = dialog.getContentElement('info', 'protocol');
                var protocol = protocolField ? protocolField.getValue() : '';
                var combined = value;

                if (protocol && protocol !== '<other>' && value.indexOf(protocol) !== 0) {
                    combined = protocol + value;
                }

                var issue = getLinkIssue(combined);
                if (issue) {
                    alert(issue);
                    return false;
                }
                return originalValidate ? originalValidate.apply(this, arguments) : true;
            };
            urlField.fbLinkGuardWrapped = true;
        });
    }

    if (typeof CKEDITOR !== 'undefined') {
        CKEDITOR.plugins.add('fb_link_guard', {
            requires: 'notification',
            init: function (editor) {
                editor.addContentsCss(CKEDITOR.getUrl(CKEDITOR.plugins.getPath('fb_link_guard') + 'styles.css'));
                var debouncedScan = debounce(function () {
                    scanEditor(editor);
                }, 350);

                editor.on('instanceReady', function () { scanEditor(editor); });
                editor.on('paste', function () { window.setTimeout(function () { scanEditor(editor); }, 0); });
                editor.on('afterPaste', function () { scanEditor(editor); });
                editor.on('change', debouncedScan);
                editor.on('blur', function () { scanEditor(editor); });
                attachDialogValidation(editor);
            }
        });
    }

    if (typeof module !== 'undefined' && module.exports) {
        module.exports = { getLinkIssue: getLinkIssue };
    }
}());
