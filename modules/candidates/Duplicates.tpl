<?php
/**
* Candidate template for Duplicates
* @package OpenCATS
* @subpackage modules/candidates
* @copyright (C) OpenCats
* @license GNU/GPL, see license.txt
* OpenCATS is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License 2
* as published by the Free Software Foundation.
*/
?>
<?php TemplateUtility::printHeader('Candidates', array( 'js/highlightrows.js', 'js/export.js', 'js/dataGrid.js'), 'List of duplicates'); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active); ?>
<?php $md5InstanceName = md5($this->dataGrid->getInstanceName());?>
    <style type="text/css">
    div.addCandidateButton { background: #4172E3 url(images/nodata/candidatesButton.jpg); cursor: pointer; width: 337px; height: 67px; }
    div.addCandidateButton:hover { background: #4172E3 url(images/nodata/candidateButton-o.jpg); cursor: pointer; width: 337px; height: 67px; }
    div.addMassImportButton { background: #4172E3 url(images/nodata/addMassImport.jpg); cursor: pointer; width: 337px; height: 67px; }
    div.addMassImportButton:hover { background: #4172E3 url(images/nodata/addMassImport-o.jpg); cursor: pointer; width: 337px; height: 67px; }
    </style>
    <div id="main">
        <?php TemplateUtility::printQuickSearch(); ?>

        <div id="contents"<?php echo !$this->totalDuplicates ? ' style="background-color: #E6EEFF; padding: 0px;"' : ''; ?>>
            <?php if ($this->totalDuplicates): ?>
            <table width="100%">
                <tr>
                    <td width="3%">
                        <img src="images/candidate.gif" width="24" height="24" alt="Candidates" style="border: none; margin-top: 3px;" />&nbsp;
                    </td>
                    <td><h2>Duplicates: Home</h2></td>
                    <td align="right">
                        <form name="candidatesViewSelectorForm" id="candidatesViewSelectorForm" action="<?php echo(CATSUtility::getIndexName()); ?>" method="get">
                            <input type="hidden" name="m" value="candidates" />
                            <input type="hidden" name="a" value="listByView" />

                            <table class="viewSelector">
                                <tr>
                                    <td valign="top" align="right" nowrap="nowrap">
                                        <?php $this->dataGrid->printNavigation(false); ?>
                                    </td>
                                    <td valign="top" align="right" nowrap="nowrap">
                                        <input type="checkbox" name="onlyMyCandidates" id="onlyMyCandidates" <?php if ($this->dataGrid->getFilterValue('OwnerID') ==  $this->userID): ?>checked<?php endif; ?> onclick="<?php echo $this->dataGrid->getJSAddRemoveFilterFromCheckbox('OwnerID', '==',  $this->userID); ?>" />
                                        Only My Candidates&nbsp;
                                    </td>
                                    <td valign="top" align="right" nowrap="nowrap">
                                        <input type="checkbox" name="onlyHotCandidates" id="onlyHotCandidates" <?php if ($this->dataGrid->getFilterValue('IsHot') == '1'): ?>checked<?php endif; ?> onclick="<?php echo $this->dataGrid->getJSAddRemoveFilterFromCheckbox('IsHot', '==', '\'1\''); ?>" />
                                        <label for="onlyHotCandidates">Only Hot Candidates</label>&nbsp;
                                    </td>
                                    <td valign="top" align="right" nowrap="nowrap">
	                					<a href="javascript:void(0);" id="exportBoxLink<?= $md5InstanceName ?>" onclick="toggleHideShowControls('<?= $md5InstanceName ?>-tags'); return false;">Filter by tag</a>
	                					<div id="tagsContainer" style="position:relative">
	                					<div class="ajaxSearchResults" id="ColumnBox<?= $md5InstanceName ?>-tags" align="left"  style="position:absolute;width:200px;<?= $this->globalStyle ?>">
	                						<table width="100%"><tr><td style="font-weight:bold; color:#000000;">Tag list</td>
	                						<td align="right">
	                							<input type="button" onclick="applyTagFilter()" value="Save&amp;Close" />
	                							<input type="button" onclick="document.getElementById('ColumnBox<?= $md5InstanceName?>').style.display='none';" value="Close" />
	                						</td>
	                						</tr></table>


	                                        <ul>
	                                        <script type="text/javascript">
	                                        function applyTagFilter(){
	                                        	var arrValues=[];
	                                        	var tags=document.getElementsByName('candidate_tags[]');
	                                        	for(var el in tags){
	                                        		if (tags[el].checked) arrValues.push(tags[el].value);
	                                        	};

	                                        	<?php echo $this->dataGrid->getJSAddFilter('Tags', '=#',  "arrValues.join('/')")?>;
	                                        }
	                                        </script>
											<?php $i=1;

											function drw($data, $id){
												global $i;
												foreach($data as $k => $v){
													if ($v['tag_parent_id'] == $id){
														?><li><input type="checkbox" name="candidate_tags[]" id="checkbox<?= $i ?>" value="<?= $v['tag_id'] ?>"><label for="checkbox<?= $i++ ?>"><?= $v['tag_title'] ?></label></li><?php
														echo "\n<ul>";
														drw($data, $v['tag_id']);
														echo "\n</ul>";
													}
												}
											}
											drw($this->tagsRS, '');
											?></ul>
	                					</div>
	                					</div>
										<span style="display:none;" id="ajaxTableIndicator<?= $md5InstanceName ?>"><img src="images/indicator_small.gif" alt="" /></span>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </td>
                </tr>
            </table>

            <?php if ($this->topLog != ''): ?>
            <div style="margin: 20px 0px 20px 0px;">
                <?php echo $this->topLog; ?>
            </div>
            <?php endif; ?>

            <?php if ($this->errMessage != ''): ?>
            <div id="errorMessage" style="padding: 25px 0px 25px 0px; border-top: 1px solid #800000; border-bottom: 1px solid #800000; background-color: #f7f7f7;margin-bottom: 15px;">
            <table>
                <tr>
                    <td align="left" valign="center" style="padding-right: 5px;">
                        <img src="images/large_error.gif" align="left">
                    </td>
                    <td align="left" valign="center">
                        <span style="font-size: 12pt; font-weight: bold; color: #800000; line-height: 12pt;">There was a problem with your request:</span>
                        <div style="font-size: 10pt; font-weight: bold; padding: 3px 0px 0px 0px;"><?php echo $this->errMessage; ?></div>
                    </td>
                </tr>
            </table>
            </div>
            <?php endif; ?>

            <p class="note">
                <span style="float:left;">Duplicates - Page <?php echo($this->dataGrid->getCurrentPageHTML()); ?> (<?php echo($this->dataGrid->getNumberOfRows()); ?> Items)</span>
                <span style="float:right;">
                    <?php $this->dataGrid->drawRowsPerPageSelector(); ?>
                    <?php $this->dataGrid->drawShowFilterControl(); ?>
                </span>&nbsp;
            </p>

            <?php $this->dataGrid->drawFilterArea(); ?>
            <?php $this->dataGrid->draw();  ?>

            <div style="display:block;">
                <span style="float:left;">
                    <?php $this->dataGrid->printActionArea(); ?>
                </span>
                <span style="float:right;">
                    <?php $this->dataGrid->printNavigation(true); ?>
                </span>&nbsp;
            </div>

            <?php else: ?>

            <br /><br /><br /><br />
            <div style="height: 207px; background: #E6EEFF url(images/nodata/dashboardNoCandidates.jpg);">
                &nbsp;
            </div>
            <br /><br />


            <?php endif; ?>
        </div>
    </div>

    <div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
