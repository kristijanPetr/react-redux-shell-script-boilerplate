#! /bin/bash

if [ -e package.json ]
then
    echo "ok"
    npm install --save redux react-redux redux-thunk redux-logger
else
    echo "You are in a wrong Directory!"
    exit 0
fi

mkdir src src/actions src/reducers src/store
cat > src/constants.js << EOF
export const LOGGED_USER = "LOGGED_USER";
EOF

#create actions and example action
cat > src/actions/index.js << EOF
import {
  LOGGED_USER
} from "../constants";
// Example actions with thunk dispatch

export function logUser(userObj) {
  return (dispatch,getState) => {
        dispatch(logUser(userObj));
  };
}

function logUser(userObj) {
  console.log("Action Log User", userObj);
  const action = {
    type: LOGGED_USER,
    user: userObj
  };
  return action;
}
EOF

cat > src/reducers/reducer_user.js << EOF
import { LOGGED_USER } from "../constants";

export default (state = null, action) => {
  switch (action.type) {
    case LOGGED_USER:
      return action.user;
    default:
      return state;
  }
};
EOF

cat > src/reducers/index.js << EOF
import { combineReducers } from "redux";
import user from "./reducer_user";

export default combineReducers({
    user
});
EOF

cat > src/store/configureStore.js << EOF
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import logger from "redux-logger";
import rootReducer from "../reducers";

export default function configureStore() {
  return createStore(rootReducer, applyMiddleware(thunk,logger));
}
EOF

#Finally add store to Root Component
printf '\e[1;34m%-6s\e[m' "Success!
Add these lines to your Root Component
import { Provider } from 'react-redux';
import configureStore from './src/store/configureStore';
const store = configureStore();
Wrap main component in <Provider store={store}> </Provider> 
"