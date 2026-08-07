import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/media_capture_section.dart';
import '../../../shared/widgets/narrative_editor_widget.dart';
import '../../../shared/models/media_item.dart';
import 'ocorrencia_wizard_data.dart';

_gpsCard(String? lat, String? lng, VoidCallback onRegistrar, VoidCallback onAtualizar) {
  if (lat != null) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: PCPEColors.successLight, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _gi('Endereco aproximado', 'Av. Conselheiro Aguiar, 4520 - Recife/PE'),
        _gi('Latitude', lat), _gi('Longitude', lng!),
        _gi('Precisao', '3 metros'), _gi('Data/Hora', '07/08/2026 13:40'),
        const SizedBox(height: 6),
        PCPEButton(label: 'Atualizar localizacao', icon: Icons.refresh, outlined: true, small: true, height: 32, onPressed: onAtualizar),
      ]),
    );
  }
  return PCPEButton(label: '📍 Registrar localizacao', icon: Icons.gps_fixed, fullWidth: true, onPressed: onRegistrar);
}

Widget _gi(String l, String v) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(children: [SizedBox(width: 80, child: Text('$l:', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: PCPEColors.success))), Expanded(child: Text(v, style: const TextStyle(fontSize: 10)))]));

class Step4ElementosLocal extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;
  const Step4ElementosLocal({super.key, required this.data, required this.onChanged});
  @override
  State<Step4ElementosLocal> createState() => _Step4ElementosLocalState();
}

class _Step4ElementosLocalState extends State<Step4ElementosLocal> {
  // Veiculos data
  static const _marcas = ['Fiat','Ford','Volkswagen','Chevrolet','Honda','Toyota','Hyundai','Renault','Nissan','Jeep','Peugeot','Citroen','Mitsubishi','BMW','Mercedes-Benz','Kia','Chery','Outra'];
  static const _modelosPorMarca = <String,List<String>>{
    'Fiat':['Argo','Cronos','Mobi','Palio','Siena','Strada','Toro','Uno','Outro'],
    'Ford':['Ka','Fiesta','Focus','EcoSport','Ranger','Fusion','Outro'],
    'Volkswagen':['Gol','Voyage','Fox','Polo','T-Cross','Nivus','Jetta','Saveiro','Outro'],
    'Chevrolet':['Onix','Prisma','Cruze','Spin','Tracker','S10','Outro'],
    'Honda':['Civic','Fit','City','HR-V','CR-V','Outro'],
    'Toyota':['Corolla','Etios','Yaris','Hilux','SW4','Outro'],
    'Renault':['Sandero','Logan','Duster','Kwid','Captur','Outro'],
    'Outra':['(informe manualmente)'],
  };
  static const _cores = ['Branco','Preto','Prata','Cinza','Azul','Vermelho','Verde','Amarelo','Marrom','Bege','Laranja','Roxo','Dourado','Outra','Nao identificada'];
  static const _anos = ['2026','2025','2024','2023','2022','2021','2020','2019','2018','2015','2010','2005','2000','1995','1990','1980','Nao identificado'];
  final _situacoes = ['Apreendido','Removido','Encaminhado para pericia','Liberado no local','Entregue ao proprietario','Outra'];
  final _respOpc = ['Policia Civil','Policia Militar','Perito Criminal','Auxiliar de Pericia','Outro orgao','Outro'];
  // Objetos
  final _catObjetos = ['Arma de Fogo','Arma Branca','Eletronico','Documento','Substancia','Ferramenta','Joia/Valor','Vestuario','Outra'];
  final _sugestoesObj = <String,List<String>>{
    'Arma de Fogo':['Pistola','Revolver','Espingarda','Carabina','Fuzil','Outra'],
    'Arma Branca':['Faca','Facao','Canivete','Punhal','Outra'],
    'Eletronico':['Celular','Notebook','Tablet','DVR','HD','Pen Drive','Outro'],
    'Documento':['RG','CPF','CNH','Passaporte','Certidao','Outro'],
    'Substancia':['Po branco','Erva seca','Comprimido','Liquido','Outra'],
    'Outra':[],
  };
  final _destinacoesObj = ['Coletado/Apreendido','Encaminhado a pericia','Entregue a autoridade policial','Restituido','Deixado no local','Outra'];
  final _vinculos = ['Proprietario','Vitima','Pai','Mae','Filho/Filha','Irmao/Irma','Tio/Tia','Conjuge/Companheiro(a)','Outro familiar','Representante legal','Outro'];

  // ── Veiculo form ───────────────────────────────────────────
  void _formVeiculo({VeiculoEnvolvido? v, int? idx}) {
    final placaC = TextEditingController(text: v?.placa ?? '');
    final marcaC = TextEditingController(text: v?.marca ?? '');
    final modeloC = TextEditingController(text: v?.modelo ?? '');
    final anoC = TextEditingController(text: v?.ano ?? '');
    final corC = TextEditingController(text: v?.cor ?? '');
    final obsC = TextEditingController(text: v?.observacoes ?? '');
    String sit = v?.situacao ?? 'Apreendido';
    String selMarca = v?.marca ?? '';
    String selModelo = v?.modelo ?? '';
    String? gpsLat = v?.gpsVeiculoLat;
    String? gpsLng = v?.gpsVeiculoLng;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: PCPEColors.lightGray, borderRadius: BorderRadius.circular(2))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24,8,24,24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(v==null?'Novo Veiculo':'Editar Veiculo', style: const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
          const SizedBox(height: 16),
          PCPEInput(label: 'Placa', prefixIcon: Icons.confirmation_number, controller: placaC, hint: 'ABC-1234'),
          const SizedBox(height: 12),
          _autoComplete('Marca', selMarca, _marcas, (val) { ss(() { selMarca = val; marcaC.text = val; selModelo = ''; modeloC.text = ''; }); }),
          const SizedBox(height: 12),
          _autoComplete('Modelo', selModelo, _modelosPorMarca[selMarca] ?? _modelosPorMarca['Outra']!, (val) { ss(() { selModelo = val; modeloC.text = val; }); }),
          const SizedBox(height: 12),
          _dd('Ano', anoC.text, _anos, (val) { anoC.text = val!; }),
          const SizedBox(height: 12),
          Text('Cor', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PCPEColors.darkGray)),
          const SizedBox(height: 4),
          Wrap(spacing: 4, runSpacing: 4, children: _cores.map((c) => ChoiceChip(label: Text(c, style: TextStyle(fontSize: 11, color: corC.text==c?PCPEColors.pureWhite:PCPEColors.darkGray)), selected: corC.text==c, selectedColor: PCPEColors.primary, backgroundColor: PCPEColors.cardGray, onSelected: (_) => ss(() => corC.text = c), visualDensity: VisualDensity.compact)).toList()),
          if (corC.text=='Outra') ...[const SizedBox(height: 8), PCPEInput(hint: 'Descreva a cor', prefixIcon: Icons.color_lens, controller: TextEditingController(), onChanged: (val) => ss(() => corC.text = 'Outra: $val'))],
          const SizedBox(height: 14),
          // ── GPS ─────────────────────────────────────────────
          _gpsCard(gpsLat, gpsLng, () => ss(() { gpsLat = '-8.047620'; gpsLng = '-34.877030'; }), () => ss(() { gpsLat = null; gpsLng = null; })),
          const SizedBox(height: 14),
          // ── Destinacao ──────────────────────────────────────
          _dd('Destinacao', sit, _situacoes, (val) => ss(() => sit = val!)),
          if (['Apreendido','Removido','Encaminhado para pericia'].contains(sit)) ...[
            const SizedBox(height: 10),
            _dd('Responsavel', v?.responsavel ?? 'Policia Civil', _respOpc, (val) { if (v != null) v.responsavel = val!; }),
          ],
          if (['Liberado no local','Entregue ao proprietario'].contains(sit)) ...[
            const SizedBox(height: 10),
            PCPEInput(label: 'Entregue a', hint: 'Nome', prefixIcon: Icons.person, controller: TextEditingController(text: v?.destinatario ?? '')),
            const SizedBox(height: 8),
            PCPEInput(label: 'Documento', hint: 'CPF/RG', prefixIcon: Icons.badge, controller: TextEditingController(text: v?.docDestinatario ?? '')),
            const SizedBox(height: 8),
            PCPEInput(label: 'Relacao/Vinculo', hint: 'Ex: proprietario', prefixIcon: Icons.link, controller: TextEditingController(text: v?.vinculo ?? '')),
          ],
          const SizedBox(height: 14),
          NarrativeEditorWidget(textController: obsC, hint: 'Observacoes sobre o veiculo...'),
          const SizedBox(height: 20),
          Row(children: [Expanded(child: PCPEButton(label:'Cancelar',outlined:true,fullWidth:true,onPressed:()=>Navigator.pop(ctx))), const SizedBox(width:12), Expanded(child: PCPEButton(label:v==null?'Adicionar':'Salvar',icon:Icons.save,fullWidth:true,onPressed:(){
            final veic = VeiculoEnvolvido(placa:placaC.text,marca:marcaC.text,modelo:modeloC.text,ano:anoC.text,cor:corC.text,situacao:sit,observacoes:obsC.text,midias:v?.midias??[],gpsVeiculoLat:gpsLat,gpsVeiculoLng:gpsLng);
            if(v!=null&&idx!=null){widget.data.veiculos[idx]=veic;}else{widget.data.veiculos.add(veic);}
            widget.onChanged();Navigator.pop(ctx);
          }))]),
        ]))),
      ]),
    )));
  }

  // ── Objeto form ────────────────────────────────────────────
  void _formObjeto({ObjetoRelacionado? o, int? idx}) {
    final catC = TextEditingController(text: o?.categoria ?? '');
    final descC = TextEditingController(text: o?.descricao ?? '');
    int qtd = o?.quantidade ?? 1;
    final obsC = TextEditingController(text: o?.observacoes ?? '');
    String sit = o?.destinacao ?? 'Coletado/Apreendido';
    String selCat = o?.categoria ?? '';
    String? gpsLat = o?.gpsObjetoLat;
    String? gpsLng = o?.gpsObjetoLng;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: PCPEColors.lightGray, borderRadius: BorderRadius.circular(2))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24,8,24,24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(o==null?'Novo Objeto':'Editar Objeto', style: const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
          const SizedBox(height: 16),
          _dd('Categoria', selCat, _catObjetos, (val) { ss(() { selCat = val!; }); catC.text = val!; }),
          if (selCat.isNotEmpty && _sugestoesObj[selCat]!=null && _sugestoesObj[selCat]!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 4, runSpacing: 4, children: _sugestoesObj[selCat]!.map((s) => ActionChip(label: Text(s, style: const TextStyle(fontSize:11)), onPressed: () { descC.text = s; widget.onChanged(); }, visualDensity: VisualDensity.compact)).toList()),
          ],
          const SizedBox(height: 12),
          NarrativeEditorWidget(textController: descC, hint: 'Descricao do objeto...'),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Quantidade:', style: TextStyle(fontSize:13,fontWeight:FontWeight.w600)),
            const SizedBox(width:12),
            IconButton(icon: const Icon(Icons.remove_circle_outline, color: PCPEColors.primary), onPressed: () => ss(() { if (qtd>1) qtd--; })),
            Text('$qtd', style: const TextStyle(fontSize:18, fontWeight:FontWeight.w700)),
            IconButton(icon: const Icon(Icons.add_circle_outline, color: PCPEColors.primary), onPressed: () => ss(() => qtd++)),
          ]),
          const SizedBox(height: 14),
          // GPS
          _gpsCard(gpsLat, gpsLng, () => ss(() { gpsLat = '-8.047620'; gpsLng = '-34.877030'; }), () => ss(() { gpsLat = null; gpsLng = null; })),
          const SizedBox(height: 14),
          // Destinacao
          _dd('Destinacao', sit, _destinacoesObj, (val) => ss(() => sit = val!)),
          if (['Coletado/Apreendido','Encaminhado a pericia','Entregue a autoridade policial'].contains(sit)) ...[
            const SizedBox(height: 10),
            _dd('Responsavel', o?.responsavel ?? 'Perito Criminal', ['Perito Criminal','Auxiliar de Pericia','Policia Civil','Policia Militar','Outro'], (val) { if (o!=null) o.responsavel = val!; }),
          ],
          if (sit == 'Restituido') ...[
            const SizedBox(height: 10),
            PCPEInput(label: 'Restituido a', hint: 'Nome', prefixIcon: Icons.person, controller: TextEditingController(text: o?.destinatario ?? '')),
            const SizedBox(height: 8),
            PCPEInput(label: 'Documento', hint: 'CPF/RG', prefixIcon: Icons.badge, controller: TextEditingController(text: o?.docDestinatario ?? '')),
            const SizedBox(height: 8),
            _dd('Vinculo', o?.vinculo ?? 'Proprietario', _vinculos, (val) { if (o!=null) o.vinculo = val!; }),
          ],
          const SizedBox(height: 14),
          NarrativeEditorWidget(textController: obsC, hint: 'Observacoes sobre o objeto...'),
          const SizedBox(height: 20),
          Row(children: [Expanded(child: PCPEButton(label:'Cancelar',outlined:true,fullWidth:true,onPressed:()=>Navigator.pop(ctx))), const SizedBox(width:12), Expanded(child: PCPEButton(label:o==null?'Adicionar':'Salvar',icon:Icons.save,fullWidth:true,onPressed:(){
            final obj = ObjetoRelacionado(categoria:selCat,descricao:descC.text,quantidade:qtd,destinacao:sit,observacoes:obsC.text,midias:o?.midias??[],gpsObjetoLat:gpsLat,gpsObjetoLng:gpsLng);
            if(o!=null&&idx!=null){widget.data.objetos[idx]=obj;}else{widget.data.objetos.add(obj);}
            widget.onChanged();Navigator.pop(ctx);
          }))]),
        ]))),
      ]),
    )));
  }

  // ── Vestigios (existing, unchanged) ────────────────────────
  final _tiposVestigio = ['Balistico','Biologico','Papiloscopico','Digital','Quimico','Documental','Outro'];
  final _sugestoesV = <String,List<String>>{
    'Balistico':['Capsula','Estojo','Projetil','Fragmento','Cartucho intacto'],
    'Biologico':['Sangue','Tecido','Cabelo','Pelo','Osso','Fluido corporal'],
    'Papiloscopico':['Impressao digital','Impressao palmar','Impressao plantar'],
    'Digital':['Celular','Notebook','HD','Pen Drive','DVR','Camera'],
    'Outro':[],
  };
  final _respColeta = ['Perito Criminal','Auxiliar de Pericia','Policia Civil','Policia Militar','Outro'];

  void _formVestigio({VestigioEncontrado? v, int? idx}) {
    final tipoC = TextEditingController(text: v?.tipo ?? '');
    final descC = TextEditingController(text: v?.descricao ?? '');
    final locC = TextEditingController(text: v?.localizacao ?? '');
    final obsC = TextEditingController(text: v?.observacoes ?? '');
    bool coletado = v?.coletado ?? false;
    String resp = v?.responsavel ?? 'Perito Criminal';
    String selTipo = v?.tipo ?? '';
    final hasGps = v?.localizacao.contains('-8.') ?? false;
    String? gpsLat = hasGps ? '-8.047620' : null;
    String? gpsLng = gpsLat != null ? '-34.877030' : null;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: PCPEColors.lightGray, borderRadius: BorderRadius.circular(2))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24,8,24,24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(v==null?'Novo Vestigio':'Editar Vestigio', style: const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
          const SizedBox(height: 16),
          _dd('Tipo', selTipo, _tiposVestigio, (val) { ss(() { selTipo = val!; }); tipoC.text = val!; }),
          if (selTipo.isNotEmpty && _sugestoesV[selTipo]!=null && _sugestoesV[selTipo]!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing:4,runSpacing:4,children:_sugestoesV[selTipo]!.map((s)=>ActionChip(label:Text(s,style:const TextStyle(fontSize:11)),onPressed:(){descC.text=s;widget.onChanged();},visualDensity:VisualDensity.compact)).toList()),
          ],
          const SizedBox(height: 12),
          NarrativeEditorWidget(textController:descC,hint:'Descricao do vestigio...'),
          const SizedBox(height: 14),
          _gpsCard(gpsLat,gpsLng,()=>ss((){gpsLat='-8.047620';gpsLng='-34.877030';locC.text='Av. Conselheiro Aguiar, 4520 - Recife/PE';}),()=>ss((){gpsLat=null;gpsLng=null;locC.text='';})),
          const SizedBox(height: 14),
          SwitchListTile(value:coletado,onChanged:(val)=>ss(()=>coletado=val??false),title:const Text('Coletado',style:TextStyle(fontSize:14,fontWeight:FontWeight.w600)),activeColor:PCPEColors.success,contentPadding:EdgeInsets.zero),
          if(coletado)...[const SizedBox(height:8),_dd('Responsavel pela coleta',resp,_respColeta,(val)=>ss(()=>resp=val!))],
          const SizedBox(height: 14),
          NarrativeEditorWidget(textController:obsC,hint:'Observacoes sobre o vestigio...'),
          const SizedBox(height: 20),
          Row(children:[Expanded(child:PCPEButton(label:'Cancelar',outlined:true,fullWidth:true,onPressed:()=>Navigator.pop(ctx))),const SizedBox(width:12),Expanded(child:PCPEButton(label:v==null?'Adicionar':'Salvar',icon:Icons.save,fullWidth:true,onPressed:(){
            final vest=VestigioEncontrado(tipo:tipoC.text,descricao:descC.text,localizacao:locC.text,coletado:coletado,responsavel:coletado?resp:'',observacoes:obsC.text,midias:v?.midias??[]);
            if(v!=null&&idx!=null){widget.data.vestigios[idx]=vest;}else{widget.data.vestigios.add(vest);}
            widget.onChanged();Navigator.pop(ctx);
          }))]),
        ]))),
      ]),
    )));
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _autoComplete(String label, String value, List<String> opts, ValueChanged<String> onSel) => Autocomplete<String>(
    optionsBuilder:(v)=>v.text.isEmpty?opts:opts.where((o)=>o.toLowerCase().contains(v.text.toLowerCase())),
    fieldViewBuilder:(ctx,tCtrl,focusNode,_)=>TextField(controller:tCtrl,focusNode:focusNode,decoration:_dec(label).copyWith(prefixIcon:const Icon(Icons.search)),style:const TextStyle(fontSize:14),onTap:()=>tCtrl.selection=TextSelection(baseOffset:0,extentOffset:tCtrl.text.length)),
    onSelected:onSel,
  );

  Widget _dd(String label, String val, List<String> items, ValueChanged<String?> cb) => DropdownButtonFormField<String>(value:items.contains(val)?val:items.first,decoration:_dec(label),items:items.map((i)=>DropdownMenuItem(value:i,child:Text(i))).toList(),onChanged:cb);

  InputDecoration _dec(String label) => InputDecoration(labelText:label,filled:true,fillColor:PCPEColors.cardGray,border:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide(color:PCPEColors.lightGray.withValues(alpha:0.5))),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide(color:PCPEColors.lightGray.withValues(alpha:0.5))),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:const BorderSide(color:PCPEColors.primary,width:2)));

  void _galeria(List<MediaItem> midias, String titulo, VoidCallback onCh) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: PCPEColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: PCPEColors.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MediaCaptureSection(
                midias: midias,
                onChanged: () {
                  setState(() {});
                  onCh();
                },
                title: titulo,
                subtitle: 'Fotos vinculadas',
                gpsTexto: widget.data.gpsCapturado
                    ? '${widget.data.latitude}, ${widget.data.longitude}'
                    : 'GPS nao disponivel',
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Cards ──────────────────────────────────────────────────
  Widget _cardVeiculo(MapEntry<int, VeiculoEnvolvido> e) {
    final v=e.value;final i=e.key;
    return Container(margin:const EdgeInsets.only(bottom:6),padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:PCPEColors.cardGray,borderRadius:BorderRadius.circular(8)),
      child:Row(children:[
        Container(padding:const EdgeInsets.all(6),decoration:BoxDecoration(color:PCPEColors.primary.withValues(alpha:0.1),borderRadius:BorderRadius.circular(6)),child:const Icon(Icons.directions_car,size:18,color:PCPEColors.primary)),
        const SizedBox(width:10),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(v.placa.isNotEmpty?v.placa:'Sem placa',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          if(v.marca.isNotEmpty||v.modelo.isNotEmpty)Text('${v.marca} ${v.modelo}'.trim(),style:const TextStyle(fontSize:11,color:PCPEColors.mediumGray)),
          if(v.situacao.isNotEmpty)Text(v.situacao,style:const TextStyle(fontSize:10,color:PCPEColors.mediumGray)),
          if(v.gpsVeiculoLat!=null)Row(children:[const Icon(Icons.gps_fixed,size:10,color:PCPEColors.info),const SizedBox(width:2),const Text('GPS',style:TextStyle(fontSize:10,color:PCPEColors.info))]),
          if(v.midias.isNotEmpty)Row(children:[const Icon(Icons.photo_camera,size:12,color:PCPEColors.primary),const SizedBox(width:2),Text('${v.midias.length} fotos',style:const TextStyle(fontSize:10,color:PCPEColors.primary))]),
        ])),
        Column(children:[
          IconButton(icon:const Icon(Icons.photo_camera,size:18),onPressed:()=>_galeria(v.midias,'Fotos do Veiculo',widget.onChanged),color:PCPEColors.primary),
          IconButton(icon:const Icon(Icons.edit,size:18),onPressed:()=>_formVeiculo(v:v,idx:i),color:PCPEColors.mediumGray),
          IconButton(icon:const Icon(Icons.delete_outline,size:18,color:PCPEColors.error),onPressed:(){showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Excluir'),content:const Text('Tem certeza?'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancelar')),ElevatedButton(onPressed:(){setState(()=>widget.data.veiculos.removeAt(i));widget.onChanged();Navigator.pop(ctx);},style:ElevatedButton.styleFrom(backgroundColor:PCPEColors.error),child:const Text('Excluir'))]));}),
        ]),
      ]),
    );
  }

  Widget _cardObjeto(MapEntry<int, ObjetoRelacionado> e) {
    final o=e.value;final i=e.key;
    return Container(margin:const EdgeInsets.only(bottom:6),padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:PCPEColors.cardGray,borderRadius:BorderRadius.circular(8)),
      child:Row(children:[
        Container(padding:const EdgeInsets.all(6),decoration:BoxDecoration(color:PCPEColors.info.withValues(alpha:0.1),borderRadius:BorderRadius.circular(6)),child:const Icon(Icons.inventory_2,size:18,color:PCPEColors.info)),
        const SizedBox(width:10),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          if(o.categoria.isNotEmpty)Text(o.categoria,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700)),
          if(o.descricao.isNotEmpty)Text(o.descricao,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,color:PCPEColors.darkGray)),
          Text('Qtd: ${o.quantidade}  •  ${o.destinacao.isNotEmpty?o.destinacao:o.situacao}',style:const TextStyle(fontSize:10,color:PCPEColors.mediumGray)),
          if(o.gpsObjetoLat!=null)Row(children:[const Icon(Icons.gps_fixed,size:10,color:PCPEColors.info),const SizedBox(width:2),const Text('GPS',style:TextStyle(fontSize:10,color:PCPEColors.info))]),
          if(o.midias.isNotEmpty)Row(children:[const Icon(Icons.photo_camera,size:12,color:PCPEColors.primary),const SizedBox(width:2),Text('${o.midias.length} fotos',style:const TextStyle(fontSize:10,color:PCPEColors.primary))]),
        ])),
        Column(children:[
          IconButton(icon:const Icon(Icons.photo_camera,size:18),onPressed:()=>_galeria(o.midias,'Fotos do Objeto',widget.onChanged),color:PCPEColors.primary),
          IconButton(icon:const Icon(Icons.edit,size:18),onPressed:()=>_formObjeto(o:o,idx:i),color:PCPEColors.mediumGray),
          IconButton(icon:const Icon(Icons.delete_outline,size:18,color:PCPEColors.error),onPressed:(){showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Excluir'),content:const Text('Tem certeza?'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancelar')),ElevatedButton(onPressed:(){setState(()=>widget.data.objetos.removeAt(i));widget.onChanged();Navigator.pop(ctx);},style:ElevatedButton.styleFrom(backgroundColor:PCPEColors.error),child:const Text('Excluir'))]));}),
        ]),
      ]),
    );
  }

  Widget _cardVestigio(MapEntry<int, VestigioEncontrado> e) {
    final v=e.value;final i=e.key;
    return Container(margin:const EdgeInsets.only(bottom:6),padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:PCPEColors.cardGray,borderRadius:BorderRadius.circular(8)),
      child:Row(children:[
        Container(padding:const EdgeInsets.all(6),decoration:BoxDecoration(color:PCPEColors.warning.withValues(alpha:0.1),borderRadius:BorderRadius.circular(6)),child:const Icon(Icons.biotech,size:18,color:PCPEColors.warning)),
        const SizedBox(width:10),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          if(v.tipo.isNotEmpty)Text(v.tipo,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700)),
          if(v.descricao.isNotEmpty)Text(v.descricao,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,color:PCPEColors.darkGray)),
          Row(children:[Icon(v.coletado?Icons.check_circle:Icons.cancel,size:12,color:v.coletado?PCPEColors.success:PCPEColors.mediumGray),const SizedBox(width:4),Text(v.coletado?(v.responsavel.isNotEmpty?v.responsavel:'Coletado'):'Nao coletado',style:TextStyle(fontSize:10,color:v.coletado?PCPEColors.success:PCPEColors.mediumGray))]),
          if(v.localizacao.isNotEmpty)Row(children:[const Icon(Icons.gps_fixed,size:10,color:PCPEColors.info),const SizedBox(width:2),Text('GPS registrado',style:const TextStyle(fontSize:10,color:PCPEColors.info))]),
          if(v.midias.isNotEmpty)Row(children:[const Icon(Icons.photo_camera,size:12,color:PCPEColors.primary),const SizedBox(width:2),Text('${v.midias.length} fotos',style:const TextStyle(fontSize:10,color:PCPEColors.primary))]),
        ])),
        Column(children:[
          IconButton(icon:const Icon(Icons.photo_camera,size:18),onPressed:()=>_galeria(v.midias,'Fotos do Vestigio',widget.onChanged),color:PCPEColors.primary),
          IconButton(icon:const Icon(Icons.edit,size:18),onPressed:()=>_formVestigio(v:v,idx:i),color:PCPEColors.mediumGray),
          IconButton(icon:const Icon(Icons.delete_outline,size:18,color:PCPEColors.error),onPressed:(){showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Excluir'),content:const Text('Tem certeza?'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancelar')),ElevatedButton(onPressed:(){setState(()=>widget.data.vestigios.removeAt(i));widget.onChanged();Navigator.pop(ctx);},style:ElevatedButton.styleFrom(backgroundColor:PCPEColors.error),child:const Text('Excluir'))]));}),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    PCPECard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      PCPESectionTitle(title:'Veiculos',icon:Icons.directions_car,subtitle:'${widget.data.veiculos.length} cadastrado(s)'),
      const SizedBox(height:8),
      ...widget.data.veiculos.asMap().entries.map(_cardVeiculo),
      PCPEButton(label:'Adicionar Veiculo',icon:Icons.add,fullWidth:true,onPressed:()=>_formVeiculo()),
    ])),
    const SizedBox(height:12),
    PCPECard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      PCPESectionTitle(title:'Objetos',icon:Icons.inventory_2,subtitle:'${widget.data.objetos.length} cadastrado(s)'),
      const SizedBox(height:8),
      ...widget.data.objetos.asMap().entries.map(_cardObjeto),
      PCPEButton(label:'Adicionar Objeto',icon:Icons.add,fullWidth:true,onPressed:()=>_formObjeto()),
    ])),
    const SizedBox(height:12),
    PCPECard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      PCPESectionTitle(title:'Vestigios',icon:Icons.biotech,subtitle:'${widget.data.vestigios.length} cadastrado(s)'),
      const SizedBox(height:8),
      ...widget.data.vestigios.asMap().entries.map(_cardVestigio),
      PCPEButton(label:'Adicionar Vestigio',icon:Icons.add,fullWidth:true,onPressed:()=>_formVestigio()),
    ])),
    const SizedBox(height:24),
  ]));
}