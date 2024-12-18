# 23.10.06.금 명사 훈련 및 테스트 
import pandas as pd
from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from joblib import dump

# 데이터 로드
df = pd.read_csv("./data/명사키워드훈련및테스트.csv", encoding="cp949")

# 형용사와 감성분류를 리스트로 전환
X = df["키워드"].tolist()
y = df["분류"].tolist()

# TF-IDF 벡터라이저
vectorizer = TfidfVectorizer()
X_tfidf = vectorizer.fit_transform(X)
print(X_tfidf)

# 데이터 분할: 훈련 세트와 테스트 세트로 나누기
X_train, X_test, y_train, y_test = train_test_split(X_tfidf, y, test_size=0.2, random_state=1234)

# 모델 선택 - 나이브 베이즈 모델
model = MultinomialNB(alpha=0.5)

# 클래스 가중치 계산
class_weights = {
    '인물': 1,
    '장소': 20911 / 17795,
    '기관': 20911 / 19050,
    '키워드': 20911 / 18305
}

# Logistic Regression 교차 검증( 머신러닝 모델의 성능을 평가)
model = LogisticRegression(class_weight=class_weights, max_iter=1000)
skfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=1234)
scores = cross_val_score(model, X_tfidf, y, cv=skfold, scoring='accuracy')

print("교차 검증 점수:", scores)
print("평균 정확도: {:.4f}".format(scores.mean()))

# 모델 학습
model.fit(X_train, y_train)

# 모델 검증
print("테스트 데이터 점수: {:.4f}".format(model.score(X_test, y_test)))

# 예측
y_pred = model.predict(X_test)

# 예측 정확도
accuracy = accuracy_score(y_test, y_pred)
print("예측 정확도: {:.2f}%".format(accuracy * 100))

# 모델 저장
model_filename = './data/logistic_regression_model.joblib'
dump(model, model_filename)

# 예측 함수
def predict_sentiment(new_data):
    processed_data = vectorizer.transform(new_data)
    prediction = model.predict(processed_data)
    return prediction

# 실제 데이터 호출
new_data = pd.read_csv("./data/명사키워드테스트.csv", encoding="cp949")
new_data_list = new_data["키워드"].tolist()
#print(new_data_list)
prediction = predict_sentiment(new_data_list)
print(prediction[:50])
# 결과 저장
result_df = pd.DataFrame({
    "키워드": new_data_list,
    "분류": prediction
})

result_df.to_csv("./data/명사키워드분류완료_logistic_regression.csv", encoding="cp949", index=False)
