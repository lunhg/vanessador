fixture("Vanessador /login").page("https://ojmrcypd.p19.weaved.com/#/login")

test "Enter email, password and then click login button", `async function (t){
        var menu = Selector('.side-menu');
        var body = Selector('.side-body');
        var email = Selector('#input_login_email');
        var password = Selector('#input_login_password');
        var button = Selector('#login-button');

        var _m = await menu()
        var _e = await email()
        var _p = await password()
        var _b = await button()
        
        await t
                .expect(_e.value)
                .eql('')
                .expect(_p.value)
                .eql('')
                .typeText(_e, 'gcravista@gmail.com')
                .typeText(_p, '..senha123')
                .click(button)
                .expect(body().child('p').textContent)
                .eql('Você já está logado')
}`
