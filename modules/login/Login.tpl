<?php /* $Id: Login.tpl 3530 2007-11-09 18:28:10Z brian $ */ ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>opencats - Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=<?php echo(HTML_ENCODING); ?>" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script type="text/javascript" src="js/lib.js"></script>
    <script type="text/javascript" src="modules/login/validator.js"></script>
    <script type="text/javascript" src="js/submodal/subModal.js"></script>
</head>
<body>
    <!-- CATS_LOGIN -->
    <?php TemplateUtility::printPopupContainer(); ?>
    <div id="contents" class="container">
        <div id="login" class="row">
        <img src="images/CATS-sig.gif" alt="Login" hspace="0" vspace="0" />
            <div id="loginText" class="col-md-6 offset-md-3">
                <div class="ctr"></div>
                <br />

                <?php if (ENABLE_DEMO_MODE && !($this->siteName != '' && $this->siteName != 'choose') || ($this->siteName == 'demo')): ?>
                    <br /><br />
                    <a href="javascript:void(0);" onclick="demoLogin(); return false;">Login to Demo Account</a><br />
                <?php endif; ?>
            </div>

            <div id="formBlock" class="col-md-6 offset-md-3">
            <form name="loginForm" id="loginForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=login&amp;a=attemptLogin<?php if ($this->reloginVars != ''): ?>&amp;reloginVars=<?php echo($this->reloginVars); ?><?php endif; ?>" method="post" onsubmit="return checkLoginForm(document.loginForm);" autocomplete="off">
                    <div id="subFormBlock">
                        <?php if ($this->siteName != '' && $this->siteName != 'choose'): ?>
                            <?php if ($this->siteNameFull == 'error'): ?>
                                <label>This site does not exist. Please check the URL and try again.</label>
                                <br />
                                <br />
                            <?php else: ?>
                                <label><?php $this->_($this->siteNameFull); ?></label>
                                <br />
                                <br />
                            <?php endif; ?>
                        <?php endif; ?>

                        <?php if ($this->siteNameFull != 'error'): ?>
                            <label id="usernameLabel" for="username">Username</label><br />
                            <input name="username" id="username" class="form-control" value="<?php if (isset($this->username)) $this->_($this->username); ?>" />
                            <br />

                            <label id="passwordLabel" for="password">Password</label><br />
                            <input type="password" name="password" id="password" class="form-control" />
                            <br />

                            <input type="submit" class="btn btn-primary" value="Login" />
                            <input type="reset" id="reset" name="reset" class="btn btn-secondary" value="Reset" />
                        <?php else: ?>
                            <br />
                            <a href="javascript:void(0);" onclick="demoLogin(); return false;">Login to Demo Account</a><br />
                        <?php endif; ?>
                        <br /><br />
                    </div>
                </form>

                <span style="line-height: 30px; font-size: 10px; padding-left: 10px;">Version <?php echo(CATSUtility::getVersion()); ?></span>
            </div>
            <div style="clear: both;"></div>
        </div>
        <br />

        <script type="text/javascript">
            <?php if ($this->siteNameFull != 'error'): ?>
                document.loginForm.username.focus();

                function demoLogin() {
                    document.getElementById('username').value = '<?php echo(DEMO_LOGIN); ?>';
                    document.getElementById('password').value = '<?php echo(DEMO_PASSWORD); ?>';
                    document.getElementById('loginForm').submit();
                }

                function defaultLogin() {
                    document.getElementById('username').value = 'admin';
                    document.getElementById('password').value = 'cats';
                    document.getElementById('loginForm').submit();
                }
            <?php endif; ?>
            <?php if (isset($_GET['defaultlogin'])): ?>
                defaultLogin();
            <?php endif; ?>
        </script>

        <div id="login">
            <?php if (!empty($this->message)): ?>
                <div>
                    <?php if ($this->messageSuccess): ?>
                        <p class="success"><?php $this->_($this->message); ?><br /></p>
                    <?php else: ?>
                        <p class="failure"><?php $this->_($this->message); ?><br /></p>
                    <?php endif; ?>
                </div>
            <?php endif; ?>
        </div>
        <div id="footerBlock">
        </div>
    </div>

    <script type="text/javascript">
        initPopUp();
    </script>
    <?php TemplateUtility::printCookieTester(); ?>
</body>
</html>
