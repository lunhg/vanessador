onCells = (sheet, opt) ->
        new Promise (resolve, reject) ->
                a = {}
                for i in [opt.min..opt.max]
                        o = a[uuid.v4()] = {}
                        _list = opt.list.split('')
                        for r in _list 
                                key = sheet[r+''+opt.min].v.replace new RegExp("/", "g"), '_'
                                if sheet[r+i] is undefined
                                        o[key] = "UNDEFINED"
                                else
                                        if key is 'ID do Curso'
                                                o[key] = uuid.v4()
                                        else
                                                o[key] = sheet[r+i].v
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
                onCells(sheet, list:list, min:min, max:max).then (cells) ->
                        _name = if _name is 'alunos' then 'estudantes' else _name
                        firebase.database().ref(_name+"/").set cells
                
                
        reader.readAsBinaryString(event.target.files[0])

