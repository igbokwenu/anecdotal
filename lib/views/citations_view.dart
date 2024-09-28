import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class CitationLinks extends StatelessWidget {
  final List<Map<String, String>> links = [
    {
      'title': 'Mycotoxins Report by the World Health Organization',
      'url': 'https://www.who.int/news-room/fact-sheets/detail/mycotoxins'
    },
    {
      'title':
          'Differential effects of exposure to toxic or nontoxic mold spores on brain inflammation and Morris water maze performance',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10460635/'
    },
    {
      'title':
          'Analysis of mold and mycotoxins in naturally infested indoor building materials',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9356937/'
    },
    {
      'title':
          'A Review of the Diagnosis and Treatment of Ochratoxin A Inhalational Exposure Associated with Human Illness and Kidney Disease including Focal Segmental Glomerulosclerosis',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3255309/'
    },
    {
      'title': 'HLA gene variations and mycotoxin toxicity: Four case reports',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/38198040/'
    },
    {
      'title':
          'A Review of the Mechanism of Injury and Treatment Approaches for Illness Resulting from Exposure to Water-Damaged Buildings, Mold, and Mycotoxins',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3654247/'
    },
    {
      'title':
          'Mold inhalation causes innate immune activation, neural, cognitive and emotional dysfunction',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7231651/'
    },
    {
      'title': 'Chronic Inflammatory Response Syndrome (CIRS)',
      'url':
          'https://www.medicinenet.com/chronic_inflammatory_response_syndrome_cirs/article.htm'
    },
    {
      'title':
          'Parliamentary Business: Biotoxin-related Illnesses in Australia',
      'url':
          'https://www.aph.gov.au/Parliamentary_Business/Committees/House/Health_Aged_Care_and_Sport/BiotoxinIllnesses/Report/section?id=committees%2Freportrep%2F024194%2F26442'
    },
    {
      'title':
          'What Is Chronic Inflammatory Response Syndrome (CIRS) and How Is It Diagnosed. 13 Clusters Symptoms',
      'url':
          'https://aspenmedcenter.com/what-is-chronic-inflammatory-response-syndrome/'
    },
    {
      'title': 'Understanding Mycotoxin-induced Illness: Part 1',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/36069791/'
    },
    {
      'title': 'Ochratoxin A: General Overview and Actual Molecular Status',
      'url': 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3153212/'
    },
    {
      'title': 'Reference Papers',
      'url': 'https://www.cirsx.com/reference-papers'
    },
  ];

  CitationLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyAppBarTitleWithAI(title: 'Citations')),
      body: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                _buildLinkPreview(links[index]['url']!, links[index]['title']!),
          );
        },
      ),
    );
  }

  Widget _buildLinkPreview(String url, String title) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              AnyLinkPreview(
                link: url,
                displayDirection: UIDirection.uiDirectionVertical,
                showMultimedia: true,
                bodyMaxLines: 3,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                errorBody: 'Unable to load preview',
                errorTitle: 'Error',
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Failed to load preview'),
                ),
                cache: const Duration(days: 7),
                backgroundColor: Colors.white,
                borderRadius: 12,
                removeElevation: true,
                boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
