onCells = (c, opt) ->
        new Promise (resolve, reject) ->
                a = {}
                for i in [opt.min..opt.max]
                        o = a[uuid.v4()] = {}
                        for r in opt.list.split('')
                                key = c[r+''+opt.offset].v.replace new RegExp("/", "g"), '_'
                                if c[r+i] is undefined
                                        o[key] = "UNDEFINED"
                                else
                                        if key is 'ID do Curso'
                                                o[key] = uuid.v4()
                                        else
                                                o[key] = c[r+i].v
                        o
                resolve a
                        
                
                
importarXLS = (event) ->
        reader = new FileReader()
        name = event.target.files[0].name
        list = event.target.list
        offset = event.target.offset
        min = event.target.min
        max = event.target.max
        reader.onload = (e) ->
                data = e.target.result
                wb = XLSX.read(data, {type: 'binary'})

                onCells(wb.Sheets[sheet], list:list, offset:offset, min:min, max:max).then (cells) ->
                        console.log cells
                        firebase.database().ref(sheet+"/").set cells
                        self.$router.push("/"+sheet)
                
                
        reader.readAsBinaryString(event.target.files[0])

