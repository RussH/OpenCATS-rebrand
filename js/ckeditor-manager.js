function placeCkEditorIn(nodeId)
{
    var extraPlugins = 'font';

    if (nodeId === 'description') {
        CKEDITOR.plugins.addExternal('fb_link_guard', 'js/ckeditor_plugins/fb_link_guard/', 'plugin.js');
        extraPlugins += ',notification,fb_link_guard';
    }

    CKEDITOR.replace(nodeId, {
        extraPlugins: extraPlugins,
        disallowedContent: 'script, iframe, img'
    });

    CKEDITOR.on('instanceReady', function(ev)
    {
        var tags = ['p', 'ol', 'ul', 'li']; // etc.

        for (var key in tags) {
            ev.editor.dataProcessor.writer.setRules(
                tags[key],
                {
                    indent : false,
                    breakBeforeOpen : false,
                    breakAfterOpen : false,
                    breakBeforeClose : false,
                    breakAfterClose : false,
                });
        }
    });
}
