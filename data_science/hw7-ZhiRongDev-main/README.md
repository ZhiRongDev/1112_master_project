# Course kaggle Competition
### 👉 [Click here to enter the competition](https://www.kaggle.com/t/e2f9e2d0a075498ea809f9619b23212a)

#### Name: 程至榮
#### Student ID: 111753151
[![](/images/Competition_page.png)](https://www.kaggle.com/t/e2f9e2d0a075498ea809f9619b23212a)


## Description
You need to develop a binary classifier to predict good loan or bad loan based on 20 features of costumers. The training data is used to train your model. Then, you submit your prediction result by applying the trained model on testing data. Your score will be based on the rank in the leaderboard.


### Dataset
- `hw7_train.csv` - the training set.
- `hw7_test.csv` - the test set. same information as training set, but without label column, which you need to predict.
- `sampleSubmission.csv` - a sample submission file in the correct format. click on the data file below, and you can review the columns of each file.
  - You must predict the label of each id, and submission files should contain two columns: ID and Prediction of the label. The prediction of the label should be -1 or 1.
    The file should contain a header and have the following format:
    ```
    id,label
    0,1
    1,-1
    2,-1
    3,1
    ```

### Evaluation

The evaluation metric for this competition is Categorization Accuracy.
<br>
<br>

$$\text{Accuracy} = \frac{\text{Number of correct predictions}}{\text{Total number of predictions}}  = \frac{TP+TN}{TP+TN+FP+FN}$$

<br>


## Score
Your score will be based on the rank in the leaderboard
- 5 pts : Top 5
- 4 pts : Top 6 ~ 10
- 3 pts : Top 11 ~ 20
- 2 pts : Top 21 ~ 40
- 1 pts : Top 40 ~
- 0 pts : no submission or no code (`hw7_YourStudentID.R`)

## Note
- Please use R version 4
- The code must be submitted to github
- Filename format of your code: `hw7_YourStudentID.R`
- Please set your team name to student id.
  ![](/images/team_name.png)

