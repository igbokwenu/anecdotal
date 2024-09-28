import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';

class CitationLinks extends StatelessWidget {
  final List<String> links = [
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10460635/',
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9356937/',
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3255309/',
    'https://pubmed.ncbi.nlm.nih.gov/38198040/',
    'https://www.who.int/news-room/fact-sheets/detail/mycotoxins',
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3654247/',
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7231651/',
    'https://www.medicinenet.com/chronic_inflammatory_response_syndrome_cirs/article.htm',
    'https://www.aph.gov.au/Parliamentary_Business/Committees/House/Health_Aged_Care_and_Sport/BiotoxinIllnesses/Report/section?id=committees%2Freportrep%2F024194%2F26442',
    'https://aspenmedcenter.com/what-is-chronic-inflammatory-response-syndrome/',
    'https://pubmed.ncbi.nlm.nih.gov/36069791/',
    'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3153212/',
    'https://www.cirsx.com/reference-papers',
  ];

  CitationLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Citation Links')),
      body: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Link ${index + 1}'),
            onTap: () => _showLinkPreview(context, links[index]),
          );
        },
      ),
    );
  }

  void _showLinkPreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Link Preview'),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AnyLinkPreview(
                        link: url,
                        displayDirection: UIDirection.uiDirectionVertical,
                        showMultimedia: true,
                        bodyMaxLines: 5,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        titleStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        errorBody: 'Oops! Unable to load preview',
                        errorTitle: 'Error',
                        errorWidget: Container(
                          color: Colors.grey[300],
                          child: Text('Failed to load preview'),
                        ),
                        errorImage: "https://google.com/",
                        cache: Duration(days: 7),
                        backgroundColor: Colors.white,
                        borderRadius: 12,
                        removeElevation: false,
                        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                        onTap: () {}, // Add your onTap logic here
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}