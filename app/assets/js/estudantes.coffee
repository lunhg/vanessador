importarXLS = (event) ->
        reader = new FileReader()
        name = event.target.files[0].name
        self = this
        reader.onload = (e) ->
                data = e.target.result
                wb = XLSX.read(data, {type: 'binary'})
                roa = XLSX.utils.sheet_to_row_object_array(wb.Sheets['alunos'])
                if roa.length > 0
                        firebase.database().ref('estudantes/').set(roa)
                        firebase.database().ref('estudantes/').once 'value', (snapshot) ->
                                self.estudantes = snapshot.val()
        reader.readAsBinaryString(event.target.files[0])

