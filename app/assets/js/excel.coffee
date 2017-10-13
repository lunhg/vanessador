onCells = (sheet, opt) ->
        new Promise (resolve, reject) ->
                a = {}
                for i in [opt.min..opt.max]
                        id = uuid.v4()
                        o = a[id] = {}
                        _list = opt.list.split('')
                        for r in _list 
                                key = sheet[r+''+opt.min].v.replace new RegExp("/", "g"), '_'
                                
                                if sheet[r+i] is undefined
                                        if key is 'ID User'
                                                o[key] = id
                                        # TODO Typo no excel requer
                                        # que o correto 'Alumni' seja 'Alumini'
                                        else if key is 'Alumini(Sim_Não)'
                                                # Como isso vem de uma base de dados
                                                # vamos popular como sim, que já foi um aluno
                                                o[key] = "Sim"
                                        else
                                                unless key is 'Nome'
                                                        o[key] = "UNDEFINED"
                                else
                                        o[key] = sheet[r+i].v

                        
                        if o['ID do Curso'] then o['ID do Curso'] = id
                        if o['Nome ']
                                o['Nome'] = o['Nome ']
                                #delete o['Nome ']
                        if o['Sobrenome ']
                                o['Sobrenome'] = o['Sobrenome ']
                                #delete o['Sobrenome ']
                        
                
                resolve a
                        
                
                
importarXLS = (event) ->
        reader = new FileReader()
        name = event.target.files[0].name
        toast this.$parent, {
                title: "Excel",
                msg: "lendo arquivo #{name}"
                clickClose: true
                timeout: 10000
                position: "toast-top-right",
                type: "warning"
        }

        
        _name = this.$route.path.split('/')[1]
        list = document.getElementById('input_list').value
        min = document.getElementById('input_min').value
        max = document.getElementById('input_max').value
        self = this
        reader.onload = (e) ->
                data = e.target.result
                wb = XLSX.read(data, {type: 'binary'})
                _name = if _name is 'estudantes' then 'alunos' else _name
                sheet = wb.Sheets[_name]
                __onCells__ = (cells) ->
                        _name = if _name is 'alunos' then 'estudantes' else _name
                        toast self.$parent, {
                                title: "Excel",
                                msg: "lendo planinlha #{_name}"
                                clickClose: true
                                timeout: 10000
                                position: "toast-top-right",
                                type: "warning"
                        }
                        firebase.database().ref(_name+"/").set(cells).then ->
                                toast self.$parent, {
                                        title: "Excel",
                                        msg: "Células lidas e adicionadas ao firebase"
                                        clickClose: true
                                        timeout: 10000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                        
                onCells(sheet, list:list, min:min, max:max).then(__onCells__).then ->
                        firebase.database().ref(_name+"/").once('value').then (snapshot) ->
                                val = snapshot.val()
                                Vue.nextTick ->
                                        Vue.set self.$parent, _name, val
                                toast self.$parent, {
                                        title: _name,
                                        msg: "#{Object.keys(val).length} registrados"
                                        clickClose: true
                                        timeout: 10000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                                for k,v of snapshot.val()
                                        toast self.$parent, {
                                                title: _name
                                                msg: "#{k} registrado"
                                                clickClose: true
                                                timeout: 10000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                
                
        reader.readAsBinaryString(event.target.files[0])

