@testitem "signatures" begin
    include("../test_shared_server.jl")

    doc = settestdoc("""
    rand()
    Base.rand()
    func(arg) = 1
    func()
    struct T
        a
        b
    end
    T()
    struct S{R}
        a
        S() = new(1)
    end
    using Base:argtail
    argtail()
    S{R}()
    """)
    @test !isempty(sig_test(0, 5).signatures)
    @test !isempty(sig_test(1, 10).signatures)
    @test !isempty(sig_test(3, 5).signatures)
    @test !isempty(sig_test(8, 2).signatures)
    @test_broken !isempty(sig_test(15, 5).signatures)

    let sigs = LanguageServer.SignatureInformation[]
        LanguageServer.get_signatures(doc.cst[3].meta.binding, doc.cst.meta.scope, sigs, LanguageServer.getenv(server))
        @test length(sigs) == 1
    end
    let sigs = LanguageServer.SignatureInformation[]
        LanguageServer.get_signatures(doc.cst[5].meta.binding, doc.cst.meta.scope, sigs, LanguageServer.getenv(server))
        @test length(sigs) == 1
    end
    let sigs = LanguageServer.SignatureInformation[]
        LanguageServer.get_signatures(doc.cst[1][1].meta.ref, doc.cst.meta.scope, sigs, LanguageServer.getenv(server))
        @test length(sigs) > 0
    end
    let sigs = LanguageServer.SignatureInformation[]
        LanguageServer.get_signatures(doc.cst[7].meta.binding, doc.cst.meta.scope, sigs, LanguageServer.getenv(server))
        @test length(sigs) == 1
    end
    let sigs = LanguageServer.SignatureInformation[]
        LanguageServer.get_signatures(doc.cst[9][1].meta.ref, doc.cst.meta.scope, sigs, LanguageServer.getenv(server))
        @test length(sigs) == 1
    end
end

@testitem "definitions" begin
    include("../test_shared_server.jl")

    settestdoc("""
    rand()
    func(arg) = 1
    func()
    Float64
    """)
    # @test !isempty(def_test(0, 3))
    @test !isempty(def_test(2, 3))
    @test !isempty(def_test(3, 3))
end

@testitem "references" begin
    include("../test_shared_server.jl")

    settestdoc("""
    func(arg) = 1
    func()
    """)
    @test length(ref_test(1, 2)) == 2
end

@testitem "rename" begin
    include("../test_shared_server.jl")

    settestdoc("""
    func(arg) = 1
    func()
    """)
    @test length(rename_test(0, 2).documentChanges[1].edits) == 2
end

@testitem "get_file_loc" begin
    include("../test_shared_server.jl")

    doc = settestdoc("""
    func(arg) = 1
    func()
    """)
    @test LanguageServer.get_file_loc(doc.cst.args[2].args[1]) == (doc, 14)
end

@testitem "doc symbols" begin
    include("../test_shared_server.jl")
    
    doc = settestdoc("""
    a = 1
    b = 2
    function func() end
    function (::Bar)() end
    function (::Type{Foo})() end
    """)
    @test all(item.name in ("a", "b", "func", "::Bar", "::Type{Foo}") for item in LanguageServer.textDocument_documentSymbol_request(LanguageServer.DocumentSymbolParams(LanguageServer.TextDocumentIdentifier(uri"untitled:testdoc"), missing, missing), server, server.jr_endpoint))
end
