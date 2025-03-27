import { api, LightningElement } from 'lwc';

export default class Recipe extends LightningElement {

    @api image;
    @api title;
    @api price;
    @api time;
    @api summary;
    @api recipeId;
    dishList;
    dietList;
    @api
    set dishTypes(data) {
        this.dishList =data && data.join() ;
    }
    @api
    set diets(data) {
        this.dietList = data && data.join() ;
    }
    get dishTypes(){
        return this.dishList;
    }
    get diets(){
        return this.dietList;

    }
}