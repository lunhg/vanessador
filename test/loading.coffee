fixture("Inicialização do vanessador").page "https://qebrzjff.p19.weaved.com"

for m in [
        'Inicializando Vanessador...'
        "Loading firebase config..."
        "Loading Menu..."
        "Loading templates..."
        "_index"
        "login"
        "resetPassword"
        "confirm"
        "conta"
        "formularios"
        "estudantes"
        "cursos"
        "matriculas"
]
        _m = m
        test "Inicializador mensagem '#{m}'", (t) ->
                t.expect(Selector('#masterLoaderMessage').withText(_m)).ok()
