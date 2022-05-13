class Articles {
  int articlesPageCount;
  String pageNumber;
  List<Articles> articles;

  Articles({this.articlesPageCount, this.pageNumber, this.articles});

  Articles.fromJson(Map<String, dynamic> json) {
    articlesPageCount = json['articles_page_count'];
    pageNumber = json['page_number'];
    if (json['articles'] != null) {
      articles = new List<Articles>();
      json['articles'].forEach((v) {
        articles.add(new Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articles_page_count'] = this.articlesPageCount;
    data['page_number'] = this.pageNumber;
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticlesPost {
  int id;
  String articleName;
  String articleLocation;
  String trnDate;

  ArticlesPost({this.id, this.articleName, this.articleLocation, this.trnDate});

  ArticlesPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    articleName = json['article_name'];
    articleLocation = json['article_location'];
    trnDate = json['trn_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['article_name'] = this.articleName;
    data['article_location'] = this.articleLocation;
    data['trn_date'] = this.trnDate;
    return data;
  }
}
