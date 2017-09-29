AppManager::mailer = ->

        getTemplate = (p, opt) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                html = pug.compile(content, {filename:_p,doctype:'html'})({
                                                        curso: opt.curso
                                                        nome: opt.nome
                                                        link: opt.link
                                                })
                                                resolve html
                                        catch e
                                                reject e
                                else
                                        reject err

        @app.post '/mailer/mailgun', (req, res) ->
                res.send('SENT MAIL')
                
        @app.post '/mailer/send/:type', (req, res) ->
                self = this
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name

                to = req.query.to
                nome = req.query.nome
                curso = req.query.curso
                link = req.query.link
                getTemplate('mailer-'+req.params.type, {
                        nome: nome
                        curso: curso
                        link: link
                }).then (html) ->
                        results =
                                auth:
                                        api_key: process.env.MAILGUN_API_KEY
                                        domain: process.env.MAILGUN_DOMAIN
                                options:
                                        from: "\"Vanessador-not-reply\" <postmaster@#{results[1]}>"        
                                        to: req.query.to
                                        subject:  "[Vanessador]: Boleto - #{req.query.curso}"
                                        html: html
                .then (results) ->
                        mailer = nodemailer.createTransport nodemailer_mailgun_transport(auth:results.auth)
                        mailer.sendMail(results.options)
                                .then (r) ->
                                        res.status(201)
                                        res.json(r)
                                .catch (error) ->
                                        console.log error
                                        res.status(500)
                                        res.send(error)
                .catch (error) ->
                        console.log error
                        res.status(500)
                        res.send(error)
