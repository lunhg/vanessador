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
                                                        data: opt.data
                                                        isAlumni: opt.isAlumni
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
                nome = to.split(" <")[0]
                nome = nome.replace '\"', '' for i in [0..1]
                curso = req.query.subject.split(" - ")[1]
                Promise.all([
                        keytar.findPassword("#{projectName}.mailgun.apiKey")
                        keytar.findPassword("#{projectName}.mailgun.domain")
                        getTemplate('mailer-'+req.params.type, {
                                 nome: nome
                                 curso: curso
                                 isAlumni: req.query.alumni
                        })
                ]).then (results) ->
                        results =
                                auth:
                                        api_key: results[0]
                                        domain: results[1]
                                options:
                                        from: "\"Vanessador-not-reply\" <postmaster@#{results[1]}>"        
                                        to: req.query.to
                                        subject:  "[Vanessador]: #{req.query.subject}"
                                        html: results[2]
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
