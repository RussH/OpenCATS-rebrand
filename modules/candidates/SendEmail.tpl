<?php /* $Id: SendEmail.tpl 3078 2007-09-21 20:25:28Z will $ */ ?>
<?php TemplateUtility::printHeader('Candidates', array('vendor/ckeditor/ckeditor/ckeditor.js', 'js/ckeditor-manager.js', 'modules/candidates/validator.js', 'js/searchSaved.js', 'js/sweetTitles.js', 'js/searchAdvanced.js', 'js/highlightrows.js', 'js/export.js', 'js/emailHandler.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active); ?>
    <div id="main">
        <?php TemplateUtility::printQuickSearch(); ?>

        <div id="contents">
            <table>
                <tr>
                    <td width="3%">
                        <img src="images/candidate.gif" width="24" height="24" border="0" alt="Candidates" style="margin-top: 3px;" />&nbsp;
                    </td>
                    <td><h2>Candidates: Send E-mail</h2></td>
                </tr>
            </table>

            <p class="note">Send Candidates E-mail</p>

            <?php
            if($this->success == true)
            {
                ?>

                <br />
                <span style="font-size: 12pt; font-weight: 900;">
                Your e-mail has been successfully sent to the following recipients:
                <blockquote>
                <?php
                echo $this->success_to;
                ?>
                </blockquote>


                <?php
            }
            else
            {
                $emailTo = '';
                foreach($this->recipients as $recipient)
                {
                        if(strlen($recipient['email1']) > 0)
                        {
                            $eml = $recipient['email1'];
                        }
                        else if(strlen($recipient['email2']) > 0)
                        {
                            $eml = $recipient['email2'];
                        }
                        else
                        {
                            $eml = '';
                        }
                        if($eml != '')
                        {
                            if($emailTo != '')
                            {
                                $emailTo .= ', ';
                            }
                            $emailTo .= $eml;
                        }
                }
                $tabIndex = 1;
                ?>

            <table class="editTable" width="100%">
                <tr>
                    <td>
                        <form name="emailForm" id="emailForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=candidates&amp;a=emailCandidates" method="post" onsubmit="return checkEmailForm(document.emailForm);" autocomplete="off" enctype="multipart/form-data">
                        <input type="hidden" name="postback" id="postback" value="postback" />
                        <?php foreach($this->recipients as $data): ?>
                            <input type="hidden" name="candidateID[]" value="<?php echo($data['email1'].'='.$data['candidate_id'])?>" />
                        <?php endforeach; ?>
                        <table>
                            <tr>
                                <td class="tdVertical" style="text-align: right;">
                                    To
                                </td>
                                <td class="tdData">
                                    <textarea class="inputbox" name="emailTo" rows="2", cols="90" tabindex="99" style="width: 600px;" readonly><?php echo($emailTo); ?></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical" style="text-align: right;">
                                    <label id="emailSubjectLabel" for="emailSubject">Subject</label>
                                </td>
                                <td class="tdData">
                                    <input id="emailSubject" tabindex="<?php echo($tabIndex++); ?>" type="text" name="emailSubject" class="inputbox" style="width: 600px;" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical" style="text-align: right;">
                                    <label id="emailTemplateLabel" for="emailTemplate">Template</label>
                                </td>
                                <td class="tdData">
                                    <select id="emailTemplate" name="emailTemplate" tabindex="<?php echo($tabIndex++);?>" onchange="showTemplate('<?php echo($this->sessionCookie); ?>');">
                                        <option selected="selected" value="-1">----</option>
                                        <?php foreach($this->emailTemplatesRS as $data): ?>
                                            <option value="<?php echo($data['emailTemplateID']); ?>"><?php echo($data['emailTemplateTitle']); ?></option>
                                        <?php endforeach; ?>
                                    </select>

                                    <label id="emailPreviewLabel" for="candidateName">Preview for:</label>
                                    <select id="candidateName" tabindex="<?php echo($tabIndex++); ?>" onchange="replaceTemplateTags('<?php echo($this->sessionCookie); ?>')">
                                        <option selected="selected" value="-1">----</option>
                                        <?php foreach($this->recipients as $data): ?>
                                            <option value="<?php echo($data['candidate_id']); ?>"><?php echo($data['last_name'].", ".$data['first_name']." (".$data['email1']).")"; ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdVertical" style="text-align: right;">
                                    <label id="emailBodyLabel" for="emailBody">Body</label>
                                </td>
                                <td class="tdData">
                                    <textarea id="emailBody" tabindex="<?php echo($tabIndex++); ?>" name="emailBody" rows="10" cols="90" style="width: 600px;" class="inputbox"></textarea>
                                </td>
                                <td class="tdData">
                                    <div id="emailPreview" tabindex="<?php echo($tabIndex++); ?>" name="emailPreview" rows="10" cols="90" style="width: 600px;"></div>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="top" colspan="2">
                                    <input type="submit" tabindex="<?php echo($tabIndex++); ?>" class="button" value="Send E-Mail" />&nbsp;
                                    <input type="reset"  tabindex="<?php echo($tabIndex++); ?>" class="button" value="Reset" />&nbsp;
                                </td>
                            </tr>
                        </table>

                        </form>

			<script type="text/javascript">
                        document.emailForm.emailSubject.focus();
                        //added the code below for the ckeditor html box - Jamin 2-19-2010
                        //adjusted code to remove or prevent extra breaks in email - Jamin 2-23-2010
                        placeCkEditorIn('emailBody');
                    </script>

                    </td>
                </tr>
            </table>
            <?php
            }
            ?>
        </div>
    </div>
<?php TemplateUtility::printFooter(); ?>
