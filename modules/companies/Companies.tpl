<?php /* $Id: Companies.tpl 3460 2007-11-07 03:50:34Z brian $ */ ?>
<?php TemplateUtility::printHeader('Companies', array('js/highlightrows.js', 'js/export.js', 'js/dataGrid.js', 'js/dataGridFilters.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active); ?>

<style type="text/css">
    .addCompaniesButton {
        background-color: #4172E3;
        border: 1px solid #3366CC;
        color: white;
        font-size: 18px;
        font-weight: bold;
        height: 45px;
        width: 210px;
        text-align: center;
        cursor: pointer;
    }

    .addCompaniesButton:hover {
        background-color: #4198E3;
    }
</style>

<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="mt-4 mb-4">Companies: Home</h2>
                        </div>
                        <div class="card-body">
                            <table class="table">
                                <tr>
                                    <td width="3%">
                                        <img src="images/companies.gif" width="24" height="24" border="0" alt="Companies" style="margin-top: 3px;" />&nbsp;
                                    </td>
                                    <td><h2 class="mt-4 mb-4">Companies: Home</h2></td>
                                    <td align="right">
                                        <form name="companiesViewSelectorForm" id="companiesViewSelectorForm" action="<?php echo(CATSUtility::getIndexName()); ?>" method="get">
                                            <input type="hidden" name="m" value="companies" />
                                            <input type="hidden" name="a" value="listByView" />
                                            <div class="table-responsive">
                                                <table class="viewSelector">
                                                    <tr>
                                                        <td valign="top" align="right" nowrap="nowrap">
                                                            <?php $this->dataGrid->printNavigation(false); ?>
                                                        </td>
                                                        <td valign="top" align="right" nowrap="nowrap">
                                                            <input type="checkbox" name="onlyMyCompanies" id="onlyMyCompanies" <?php if ($this->dataGrid->getFilterValue('OwnerID') ==  $this->userID): ?>checked<?php endif; ?> onclick="<?php echo $this->dataGrid->getJSAddRemoveFilterFromCheckbox('OwnerID', '==',  $this->userID); ?>" />
                                                            <label for="onlyMyCompanies">Only My Companies</label>&nbsp;
                                                        </td>
                                                        <td valign="top" align="right" nowrap="nowrap">
                                                            <input type="checkbox" name="onlyHotCompanies" id="onlyHotCompanies" <?php if ($this->dataGrid->getFilterValue('IsHot') == '1'): ?>checked<?php endif; ?> onclick="<?php echo $this->dataGrid->getJSAddRemoveFilterFromCheckbox('IsHot', '==', '\'1\''); ?>" />
                                                            <label for="onlyHotCompanies">Only Hot Companies</label>&nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </form>
                                    </td>
                                </tr>
                            </table>

                            <?php if ($this->errMessage != ''): ?>
