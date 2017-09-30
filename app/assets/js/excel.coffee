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
                                        else if key is 'Nome ' or key is 'Sobrenome '
                                                break
                                        else
                                                o[key] = "UNDEFINED"
                                else
                                        o[key] = sheet[r+i].v

                        if a[id]['ID do Curso'] then a[id]['ID do Curso'] = id
                        if a[id]['Nome ']
                                a[id]['Nome'] = a[id]['Nome ']
                                delete a[id]['Nome ']
                        if a[id]['Sobrenome ']
                                a[id]['Sobrenome'] = a[id]['Sobrenome ']
                                delete a[id]['Sobrenome ']
                        console.log o
                                
                resolve a
                        
                
                
importarXLS = (event) ->
        reader = new FileReader()
        name = event.target.files[0].name
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
                        firebase.database().ref(_name+"/").set(cells)
                         
                onCells(sheet, list:list, min:min, max:max).then(__onCells__).then self.$options.computed[_name]
                
                
        reader.readAsBinaryString(event.target.files[0])

