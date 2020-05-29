// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:any_quote/model/quote.dart';
import 'package:any_quote/model/wikiquote.dart' as wikiquote;
import 'package:any_quote/service/quote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parse quotes', () async {
    final wikiquote.Section section = wikiquote.Section(2, '3', '1.43', '44');
    final wikiquote.Parse parse = wikiquote.Parse(
      'Kaamelott',
      wikiquote.Text(
          "<div class=\"mw-parser-output\"><h3><span class=\"mw-headline\" id=\"Mevanwi\"><a href=\"https://fr.wikipedia.org/wiki/Personnages_de_Kaamelott#Mevanwi\" class=\"extiw\" title=\"w:Personnages de Kaamelott\">Mevanwi</a></span><span class=\"mw-editsection\"><span class=\"mw-editsection-bracket\">[</span><a href=\"/w/index.php?title=Kaamelott&amp;action=edit&amp;section=1\" title=\"Modifier la section : Mevanwi\">modifier</a><span class=\"mw-editsection-bracket\">]</span></span></h3>\n<div class=\"citation\">Je voudrais, pour une fois dans ma vie, ne pas avoir l’impression de dormir dans un chenil&#160;! […] Karadoc, soit vous montez dans ce bain, soit vous me perdez.</div>\n<ul><li><div class=\"ref\"> Caroline Ferrus, <i>Kaamelott</i>, Livre II, 20&#160;: <i>Immaculé Karadoc</i>, écrit par Alexandre Astier.</div></li></ul>\n<p><br />\n</p>\n<div class=\"citation\">Selon Karadoc, un lit n’est pas un lit s'il n’y a pas de quoi manger une semaine dedans sans en sortir.</div>\n<ul><li><div class=\"ref\"> Caroline Ferrus, <i>Kaamelott</i>, Livre IV, 26&#160;: <i>La Chambre de la reine</i>, écrit par Alexandre Astier.</div></li></ul>\n<p><br />\n</p>\n<div class=\"citation\">Une fois j'ai dormi avec un porc pendant une semaine. [Arthur: Un porc entier?]\nUn porc vivant.</div>\n<ul><li><div class=\"ref\"> Caroline Ferrus, <i>Kaamelott</i>, Livre IV, 26&#160;: <i>La Chambre de la reine</i>, écrit par Alexandre Astier.</div></li></ul>\n\n<!-- \nNewPP limit report\nParsed by mw1360\nCached time: 20200519075129\nCache expiry: 2592000\nDynamic content: false\nComplications: []\nCPU time usage: 0.024 seconds\nReal time usage: 0.032 seconds\nPreprocessor visited node count: 392/1000000\nPost‐expand include size: 847/2097152 bytes\nTemplate argument size: 872/2097152 bytes\nHighest expansion depth: 12/40\nExpensive parser function count: 0/500\nUnstrip recursion depth: 0/20\nUnstrip post‐expand size: 0/5000000 bytes\nNumber of Wikibase entities loaded: 0/400\n-->\n<!--\nTransclusion expansion time report (%,ms,calls,template)\n100.00%   26.747      1 -total\n 79.37%   21.230      3 Modèle:Réf_Série\n 60.99%   16.313      3 Modèle:Réf_imprécise\n 40.87%   10.932      3 Modèle:Print\n 27.01%    7.224      3 Modèle:Concat10\n 18.42%    4.927      3 Modèle:Citation\n-->\n</div>"),
      null,
      null,
    );

    final Iterable<Quote> actualQuotes = await parseQuotes(
            Locale.fromSubtags(languageCode: 'fr'), section, parse)
        .toList();
    print(actualQuotes);
  });
}
